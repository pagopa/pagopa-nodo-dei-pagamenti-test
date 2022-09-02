Feature: idempotency checks for sendPaymentOutcomeV2

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
         <noticeNumber>311$iuv</noticeNumber>
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
         <noticeNumber>311$iuv</noticeNumber>
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
         <idempotencyKey>#idempotency_key1#</idempotencyKey>
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

   # IDMP_SPO_11

   Scenario: IDMP_SPO_11 (part 1)
      Given nodo-dei-pagamenti has config parameter useIdempotency set to true
      And wait 10 seconds for expiration
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_11 (part 2)
      Given the IDMP_SPO_11 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_12

   Scenario: IDMP_SPO_12 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_12 (part 2)
      Given the IDMP_SPO_12 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idPSP with Empty in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_13

   Scenario: IDMP_SPO_13 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_13 (part 2)
      Given the IDMP_SPO_13 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentToken with 798c6a817ed9482fa5659c45f4a25f286 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value 798c6a817ed9482fa5659c45f4a25f286 of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_14

   Scenario: IDMP_SPO_14 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_14 (part 2)
      Given the IDMP_SPO_14 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idBrokerPSP with 60000000001 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_AUTORIZZAZIONE of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_15

   Scenario: IDMP_SPO_15 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_15 (part 2)
      Given the IDMP_SPO_15 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_15 (part 3)
      Given the IDMP_SPO_15 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_16.1

   Scenario: IDMP_SPO_16.1 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_16.1 (part 2)
      Given the IDMP_SPO_16.1 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_16.1 (part 3)
      Given the IDMP_SPO_16.1 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idPSP with 60000000001 in sendPaymentOutcomeV2
      And idBrokerPSP with 60000000001 in sendPaymentOutcomeV2
      And idChannel with 60000000001_01 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_16.2

   Scenario: IDMP_SPO_16.2 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_16.2 (part 2)
      Given the IDMP_SPO_16.2 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_16.2 (part 3)
      Given the IDMP_SPO_16.2 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentMethod with cash in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_16.3

   Scenario: IDMP_SPO_16.3 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_16.3 (part 2)
      Given the IDMP_SPO_16.3 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_16.3 (part 3)
      Given the IDMP_SPO_16.3 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And streetName with street3 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_17

   Scenario: IDMP_SPO_17 (part 1)
      Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
      And wait 10 seconds for expiration
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_17 (part 2)
      Given the IDMP_SPO_17 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And update through the query update_validto of the table IDEMPOTENCY_CACHE the parameter VALID_TO with $date_plus_1_min under macro NewMod1 on db nodo_online
      And wait 65 seconds for expiration

   Scenario: IDMP_SPO_17 (part 3)
      Given the IDMP_SPO_17 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to true
      And wait 10 seconds for expiration
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_18

   Scenario: IDMP_SPO_18 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And saving activatePaymentNotice request in activatePaymentNoticeReq
      And save activatePaymentNotice response in activatePaymentNoticeResponse
      And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apn on db nodo_online under macro NewMod1

   Scenario: IDMP_SPO_18 (part 2)
      Given the IDMP_SPO_18 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apn on db nodo_online under macro NewMod1

   # IDMP_SPO_20

   Scenario: IDMP_SPO_20 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And saving activatePaymentNotice request in activatePaymentNoticeReq
      And save activatePaymentNotice response in activatePaymentNoticeResponse
      And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apn on db nodo_online under macro NewMod1
      And nodo-dei-pagamenti has config parameter useIdempotency set to false
      And wait 10 seconds for expiration

   Scenario: IDMP_SPO_20 (part 2)
      Given the IDMP_SPO_20 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And nodo-dei-pagamenti has config parameter useIdempotency set to true
      And wait 10 seconds for expiration
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apn on db nodo_online under macro NewMod1

   # IDMP_SPO_22

   Scenario: IDMP_SPO_22 (part 1)
      Given nodo-dei-pagamenti has config parameter useIdempotency set to false
      And wait 10 seconds for expiration
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And saving activatePaymentNotice request in activatePaymentNoticeReq
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_22 (part 2)
      Given the IDMP_SPO_22 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_22 (part 3)
      Given the IDMP_SPO_22 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And nodo-dei-pagamenti has config parameter useIdempotency set to true
      And wait 10 seconds for expiration

   # IDMP_SPO_26

   Scenario: IDMP_SPO_26 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And saving activatePaymentNotice request in activatePaymentNoticeReq
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_26 (part 2)
      Given the IDMP_SPO_26 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idempotencyKey with None in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_27

   Scenario: IDMP_SPO_27 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And saving activatePaymentNotice request in activatePaymentNoticeReq
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: IDMP_SPO_27 (part 2)
      Given the IDMP_SPO_27 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_27 (part 3)
      Given the IDMP_SPO_27 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idempotencyKey with #idempotency_key2# in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And check description contains Esito concorde of sendPaymentOutcomeV2 response

   # IDMP_SPO_31

   Scenario: IDMP_SPO_31 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: IDMP_SPO_31 (part 2)
      Given the IDMP_SPO_31 (part 1) scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse1

   Scenario: IDMP_SPO_31 (part 3)
      Given the IDMP_SPO_31 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeResponse1.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_31 (part 4)
      Given the IDMP_SPO_31 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

# da aggiungere in query_AutomationTest.json
# "NewMod1" : {"idempotency_spov2" : "SELECT columns FROM table_name WHERE IDEMPOTENCY_KEY = '$sendPaymentOutcomeV2.idempotencyKey'",
#              "idempotency_apn" : "SELECT columns FROM table_name WHERE IDEMPOTENCY_KEY = '$activatePaymentNoticeReq.idempotencyKey'",
#              "noticeid_pa": "SELECT columns FROM table_name WHERE NOTICE_ID = '311$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "noticeid_pa_token": "SELECT columns FROM table_name WHERE NOTICE_ID = '311$iuv' and ID_DOMINIO = '#creditor_institution_code#' AND PAYMENT_TOKEN = '$activatePaymentNoticeResponse.paymentToken' ORDER BY ID ASC",
#              "update_validto" : "UPDATE table_name SET param = TO_DATE('value', 'YYYY-MM-DD HH24:MI:SS') WHERE IDEMPOTENCY_KEY = '$sendPaymentOutcomeV2.idempotencyKey' AND PSP_ID = '$sendPaymentOutcomeV2.idPSP"}