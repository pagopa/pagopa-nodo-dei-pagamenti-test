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
         <noticeNumber>311$iuv</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response

   Scenario: activateIOPayment
      Given initial XML activateIOPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activateIOPaymentReq>
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
         </nod:activateIOPaymentReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   Scenario: closePayment
      Given initial json closePayment
         """
         {
            "paymentTokens": [
               "$activateIOPaymentResponse.paymentToken"
            ],
            "outcome": "OK",
            "idPSP": "70000000001",
            "idBrokerPSP": "70000000001",
            "idChannel": "70000000001_08",
            "paymentMethod": "BPAY",
            "transactionId": "#transaction_id#",
            "totalAmount": 12,
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
         <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
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

   # REV_SPO_03

   Scenario: REV_SPO_03 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: REV_SPO_03 (part 2)
      Given the REV_SPO_03 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: REV_SPO_03 (part 3)
      Given the REV_SPO_03 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: REV_SPO_03 (part 4)
      Given the REV_SPO_03 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.e-mail of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 11$iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777 of the record at column BROKER_PA of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777_08 of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
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
      And checks the value $closePayment.transactionId of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value v2 of the record at column CLOSE_PAYMENT of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 11$iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value test of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value company of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value office of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 11$iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777 of the record at column RECIPIENT_BROKER_PA of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777_08 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 11$iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777 of the record at column RECIPIENT_BROKER_PA of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777_08 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_RECEIPT_XML of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1

   # REV_SPO_04

   Scenario: REV_SPO_04 (part 1)
      Given the activateIOPayment scenario executed successfully
      And amount with 3.00 in activateIOPayment
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: REV_SPO_04 (part 2)
      Given the REV_SPO_04 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: REV_SPO_04 (part 3)
      Given the REV_SPO_04 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      And totalAmount with 5.00 in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 25 seconds for expiration

   Scenario: REV_SPO_04 (part 4)
      Given the REV_SPO_04 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1

# da aggiungere in query_AutomationTest.json
# "NewMod1" : {"noticeid_pa": "SELECT columns FROM table_name WHERE NOTICE_ID = '311$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "position_subject": "SELECT columns FROM table_name WHERE ENTITY_UNIQUE_IDENTIFIER_VALUE = '$activateIOPayment.entityUniqueIdentifierValue' and INSERTED_TIMESTAMP > TO_DATE ('$date','YYYY-MM-DD HH24:MI:SS')"}