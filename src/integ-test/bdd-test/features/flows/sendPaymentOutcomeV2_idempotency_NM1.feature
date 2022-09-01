Feature: idempotency checks for sendPaymentOutcomeV2

   Background:
      Given systems up
      And initial json checkPosition
         """
         {
            "positionslist": [
               {
                  "fiscalCode": "#creditor_institution_code#",
                  "noticeNumber": "310$iuv"
               },
               {
                  "fiscalCode": "#creditor_institution_code#",
                  "noticeNumber": "310$iuv1"
               }
            ]
         }
         """
      When PM sends checkPosition to nodo-dei-pagamenti
      Then check outcome is OK of checkPosition response
      And check faultCode is 200 of checkPosition response

   Scenario: activatePaymentNoticeV2
      Given initial XML activatePaymentNoticeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activatePaymentNoticeV2Request>
         <idPSP>70000000001</idPSP>
         <idBrokerPSP>70000000001</idBrokerPSP>
         <idChannel>70000000001_01</idChannel>
         <password>pwdpwdpwd</password>
         <idempotencyKey>#idempotency_key#</idempotencyKey>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>310$iuv</noticeNumber>
         </qrCode>
         <expirationTime>60000</expirationTime>
         <amount>10.00</amount>
         <paymentNote>responseFull</paymentNote>
         </nod:activatePaymentNoticeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   Scenario: closePaymentV2
      Given initial json closePaymentV2
         """
         {
            "paymentTokens": [
               "$activatePaymentNoticeV2Response.paymentToken",
               "$activatePaymentNoticeV2Response1.paymentToken"
            ],
            "outcome": "OK",
            "idPSP": "70000000001",
            "idBrokerPSP": "70000000001",
            "idChannel": "70000000001_08",
            "paymentMethod": "TPAY",
            "transactionId": "#transaction_id#",
            "totalAmount": 22,
            "fee": 2,
            "timestampOperation": "2033-04-23T18:25:43Z",
            "additionalPaymentInformations": {
               "key": "#key#"
            }
         }
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
         <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
         <paymentToken>$activatePaymentNoticeV2Response1.paymentToken</paymentToken>
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
      And the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_11 (part 2)
      Given the IDMP_SPO_11 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_11 (part 3)
      Given the IDMP_SPO_11 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_11.1

   Scenario: IDMP_SPO_11.1 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_11.1 (part 2)
      Given the IDMP_SPO_11.1 (part 1) scenario executed successfully
      And the activatePaymentNoticeV2 scenario executed successfully
      And idempotencyKey with #idempotency_key1# in activatePaymentNoticeV2
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response1

   Scenario: IDMP_SPO_11.1 (part 3)
      Given the IDMP_SPO_11.1 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_11.1 (part 4)
      Given the IDMP_SPO_11.1 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_12

   Scenario: IDMP_SPO_12 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_12 (part 2)
      Given the IDMP_SPO_12 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_12 (part 3)
      Given the IDMP_SPO_12 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idPSP with Empty in sendPaymentOutcomeV2
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_12.1

   Scenario: IDMP_SPO_12.1 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_12.1 (part 2)
      Given the IDMP_SPO_12.1 (part 1) scenario executed successfully
      And the activatePaymentNoticeV2 scenario executed successfully
      And idempotencyKey with #idempotency_key1# in activatePaymentNoticeV2
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response1

   Scenario: IDMP_SPO_12.1 (part 3)
      Given the IDMP_SPO_12.1 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_12.1 (part 4)
      Given the IDMP_SPO_12.1 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idPSP with Empty in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_13

   Scenario: IDMP_SPO_13 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_13 (part 2)
      Given the IDMP_SPO_13 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_13 (part 3)
      Given the IDMP_SPO_13 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with 798c6a817ed9482fa5659c45f4a25f286 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value 798c6a817ed9482fa5659c45f4a25f286 of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_14

   Scenario: IDMP_SPO_14 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_14 (part 2)
      Given the IDMP_SPO_14 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_14 (part 3)
      Given the IDMP_SPO_14 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idBrokerPSP with 60000000001 in sendPaymentOutcomeV2
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_AUTORIZZAZIONE of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_15

   Scenario: IDMP_SPO_15 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_15 (part 2)
      Given the IDMP_SPO_15 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_15 (part 3)
      Given the IDMP_SPO_15 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_15 (part 4)
      Given the IDMP_SPO_15 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_16.1

   Scenario: IDMP_SPO_16.1 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_16.1 (part 2)
      Given the IDMP_SPO_16.1 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_16.1 (part 3)
      Given the IDMP_SPO_16.1 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_16.1 (part 4)
      Given the IDMP_SPO_16.1 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      And idPSP with 60000000001 in sendPaymentOutcomeV2
      And idBrokerPSP with 60000000001 in sendPaymentOutcomeV2
      And idChannel with 60000000001_01 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_16.2

   Scenario: IDMP_SPO_16.2 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_16.2 (part 2)
      Given the IDMP_SPO_16.2 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_16.2 (part 3)
      Given the IDMP_SPO_16.2 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_16.2 (part 4)
      Given the IDMP_SPO_16.2 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      And paymentMethod with cash in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_16.3

   Scenario: IDMP_SPO_16.3 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_16.3 (part 2)
      Given the IDMP_SPO_16.3 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_16.3 (part 3)
      Given the IDMP_SPO_16.3 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_16.3 (part 4)
      Given the IDMP_SPO_16.3 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      And streetName with street3 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_17

   Scenario: IDMP_SPO_17 (part 1)
      Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
      And wait 10 seconds for expiration
      And the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_17 (part 2)
      Given the IDMP_SPO_17 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_17 (part 3)
      Given the IDMP_SPO_17 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And update through the query update_validto of the table IDEMPOTENCY_CACHE the parameter VALID_TO with $date_plus_1_min under macro NewMod1 on db nodo_online
      And wait 65 seconds for expiration

   Scenario: IDMP_SPO_17 (part 4)
      Given the IDMP_SPO_17 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to true
      And wait 10 seconds for expiration
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_18

   Scenario: IDMP_SPO_18 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_18 (part 2)
      Given the IDMP_SPO_18 (part 1) scenario executed successfully
      And the activatePaymentNoticeV2 scenario executed successfully
      And idempotencyKey with #idempotency_key1# in activatePaymentNoticeV2
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request1
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response1

   Scenario: IDMP_SPO_18 (part 3)
      Given the IDMP_SPO_18 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration
      And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apnv2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apnv2_1 on db nodo_online under macro NewMod1

   Scenario: IDMP_SPO_18 (part 4)
      Given the IDMP_SPO_18 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apnv2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apnv2_1 on db nodo_online under macro NewMod1

   # IDMP_SPO_20

   Scenario: IDMP_SPO_20 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_20 (part 2)
      Given the IDMP_SPO_20 (part 1) scenario executed successfully
      And the activatePaymentNoticeV2 scenario executed successfully
      And idempotencyKey with #idempotency_key1# in activatePaymentNoticeV2
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request1
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response1

   Scenario: IDMP_SPO_20 (part 3)
      Given the IDMP_SPO_20 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration
      And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apnv2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apnv2_1 on db nodo_online under macro NewMod1
      And nodo-dei-pagamenti has config parameter useIdempotency set to false
      And wait 10 seconds for expiration

   Scenario: IDMP_SPO_20 (part 4)
      Given the IDMP_SPO_20 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And nodo-dei-pagamenti has config parameter useIdempotency set to true
      And wait 10 seconds for expiration
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apnv2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_apnv2_1 on db nodo_online under macro NewMod1

   # IDMP_SPO_22

   Scenario: IDMP_SPO_22 (part 1)
      Given nodo-dei-pagamenti has config parameter useIdempotency set to false
      And wait 10 seconds for expiration
      And the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_22 (part 2)
      Given the IDMP_SPO_22 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_22 (part 3)
      Given the IDMP_SPO_22 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_22 (part 4)
      Given the IDMP_SPO_22 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And nodo-dei-pagamenti has config parameter useIdempotency set to true
      And wait 10 seconds for expiration

   # IDMP_SPO_26

   Scenario: IDMP_SPO_26 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_26 (part 2)
      Given the IDMP_SPO_26 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_26 (part 3)
      Given the IDMP_SPO_26 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      And idempotencyKey with None in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_27

   Scenario: IDMP_SPO_27 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

   Scenario: IDMP_SPO_27 (part 2)
      Given the IDMP_SPO_27 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in closePaymentV2
      And totalAmount with 12.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_27 (part 3)
      Given the IDMP_SPO_27 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_27 (part 4)
      Given the IDMP_SPO_27 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      And idempotencyKey with #idempotency_key3# in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And check description contains Esito concorde of sendPaymentOutcomeV2 response

  # IDMP_SPO_31

   Scenario: IDMP_SPO_31 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: IDMP_SPO_31 (part 2)
      Given the IDMP_SPO_31 (part 1) scenario executed successfully
      And the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response
      And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response1

   Scenario: IDMP_SPO_31 (part 3)
      Given the IDMP_SPO_31 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response1.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_31 (part 4)
      Given the IDMP_SPO_31 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentTokens with $activatePaymentNoticeV2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

# da aggiungere in query_AutomationTest.json
# "NewMod1" : {"idempotency_spov2" : "SELECT columns FROM table_name WHERE IDEMPOTENCY_KEY = '$sendPaymentOutcomeV2.idempotencyKey'",
#              "idempotency_apnv2" : "SELECT columns FROM table_name WHERE IDEMPOTENCY_KEY = '$activatePaymentNoticeV2Request.idempotencyKey'",
#              "idempotency_apnv2_1" : "SELECT columns FROM table_name WHERE IDEMPOTENCY_KEY = '$activatePaymentNoticeV2Request1.idempotencyKey'",
#              "noticeid_pa": "SELECT columns FROM table_name WHERE NOTICE_ID = '310$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "noticeid_pa_token": "SELECT columns FROM table_name WHERE NOTICE_ID = '310$iuv' and ID_DOMINIO = '#creditor_institution_code#' AND PAYMENT_TOKEN = '$activatePaymentNoticeV2Response.paymentToken' ORDER BY ID ASC",
#              "update_validto" : "UPDATE table_name SET param = TO_DATE('value', 'YYYY-MM-DD HH24:MI:SS') WHERE IDEMPOTENCY_KEY = '$sendPaymentOutcomeV2.idempotencyKey' AND PSP_ID = '$sendPaymentOutcomeV2.idPSP"}