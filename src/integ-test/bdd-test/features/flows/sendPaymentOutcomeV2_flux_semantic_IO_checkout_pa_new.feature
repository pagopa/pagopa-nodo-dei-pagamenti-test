Feature: flux / semantic checks for sendPaymentOutcomeV2

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
         </nod:activateIOPaymentReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   Scenario: closePaymentV2
      Given initial json closePaymentV2
         """
         {
            "paymentTokens": [
               "$activateIOPaymentResponse.paymentToken"
            ],
            "outcome": "OK",
            "idPSP": "70000000001",
            "idBrokerPSP": "70000000001",
            "idChannel": "70000000001_08",
            "paymentMethod": "TPAY",
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

   # SEM_SPO_7.1

   Scenario: SEM_SPO_7.1 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_7.1 (part 2)
      Given the SEM_SPO_7.1 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_7.1 (part 3)
      Given the SEM_SPO_7.1 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_7.1 (part 4)
      Given the SEM_SPO_7.1 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idChannel with 70000000001_08 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   # SEM_SPO_21

   Scenario: SEM_SPO_21 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_21 (part 2)
      Given the SEM_SPO_21 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_21 (part 3)
      Given the SEM_SPO_21 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_21 (part 4)
      Given the SEM_SPO_21 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1

   # SEM_SPO_23

   Scenario: SEM_SPO_23 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_23 (part 2)
      Given the SEM_SPO_23 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_23 (part 3)
      Given the SEM_SPO_23 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_23 (part 4)
      Given the SEM_SPO_23 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: SEM_SPO_23 (part 5)
      Given the SEM_SPO_23 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And check description contains Esito concorde of sendPaymentOutcomeV2 response

   # SEM_SPO_23.1

   Scenario: SEM_SPO_23.1 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_23.1 (part 2)
      Given the SEM_SPO_23.1 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_23.1 (part 3)
      Given the SEM_SPO_23.1 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_23.1 (part 4)
      Given the SEM_SPO_23.1 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: SEM_SPO_23.1 (part 5)
      Given the SEM_SPO_23.1 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And check description contains Esito concorde of sendPaymentOutcomeV2 response

   # SEM_SPO_28

   Scenario: SEM_SPO_28 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_28 (part 2)
      Given the SEM_SPO_28 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_28 (part 3)
      Given the SEM_SPO_28 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_28 (part 4)
      Given the SEM_SPO_28 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And outcome with KO in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome KO non accettabile of sendPaymentOutcomeV2 response

   # SEM_SPO_29

   Scenario: SEM_SPO_29 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_29 (part 2)
      Given the SEM_SPO_29 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_29 (part 3)
      Given the SEM_SPO_29 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_29 (part 4)
      Given the SEM_SPO_29 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And fee with 3.00 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response

   # SEM_SPO_31

   Scenario: SEM_SPO_31 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_31 (part 2)
      Given the SEM_SPO_31 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_31 (part 3)
      Given the SEM_SPO_31 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with 311011451292109621 under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_31 (part 4)
      Given the SEM_SPO_31 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_SCONOSCIUTO of sendPaymentOutcomeV2 response
      And update through the query update_noticeidrandom_pa of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with 311$iuv under macro NewMod1 on db nodo_online

   # SEM_SPO_32

   Scenario: SEM_SPO_32 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_32 (part 2)
      Given the SEM_SPO_32 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_32 (part 3)
      Given the SEM_SPO_32 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_32 (part 4)
      Given the SEM_SPO_32 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcomeV2 response

   # SEM_SPO_33

   Scenario: SEM_SPO_33 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_33 (part 2)
      Given the SEM_SPO_33 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_33 (part 3)
      Given the SEM_SPO_33 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_ACCEPTED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_33 (part 4)
      Given the SEM_SPO_33 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   # SEM_SPO_33.1

   Scenario: SEM_SPO_33.1 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_33.1 (part 2)
      Given the SEM_SPO_33.1 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_33.1 (part 3)
      Given the SEM_SPO_33.1 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_UNKNOWN under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_33.1 (part 4)
      Given the SEM_SPO_33.1 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table NMU_CANCEL_UTILITY retrived by the query transationid on db nodo_online under macro NewMod1

   # SEM_SPO_35.1

   Scenario: SEM_SPO_35.1 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_35.1 (part 2)
      Given the SEM_SPO_35.1 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.1 (part 3)
      Given the SEM_SPO_35.1 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter ACTIVATION_PENDING with Y under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.1 (part 4)
      Given the SEM_SPO_35.1 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_35.2

   Scenario: SEM_SPO_35.2 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_35.2 (part 2)
      Given the SEM_SPO_35.2 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.2 (part 3)
      Given the SEM_SPO_35.2 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYING under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.2 (part 4)
      Given the SEM_SPO_35.2 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_35.4

   Scenario: SEM_SPO_35.4 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_35.4 (part 2)
      Given the SEM_SPO_35.4 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.4 (part 3)
      Given the SEM_SPO_35.4 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SENT under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.4 (part 4)
      Given the SEM_SPO_35.4 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_35.5

   Scenario: SEM_SPO_35.5 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_35.5 (part 2)
      Given the SEM_SPO_35.5 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.5 (part 3)
      Given the SEM_SPO_35.5 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SEND_ERROR under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.5 (part 4)
      Given the SEM_SPO_35.5 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_35.6

   Scenario: SEM_SPO_35.6 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_35.6 (part 2)
      Given the SEM_SPO_35.6 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.6 (part 3)
      Given the SEM_SPO_35.6 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_REFUSED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.6 (part 4)
      Given the SEM_SPO_35.6 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_36

   Scenario: SEM_SPO_36 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_36 (part 2)
      Given the SEM_SPO_36 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_36 (part 3)
      Given the SEM_SPO_36 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_36 (part 4)
      Given the SEM_SPO_36 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

   # SEM_SPO_36.1

   Scenario: SEM_SPO_36.1 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse

   Scenario: SEM_SPO_36.1 (part 2)
      Given the SEM_SPO_36.1 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_36.1 (part 3)
      Given the SEM_SPO_36.1 (part 2) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with NOTIFIED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_36.1 (part 4)
      Given the SEM_SPO_36.1 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

# da aggiungere in query_AutomationTest.json
# "NewMod1" : {"update_token_pa" : "UPDATE table_name SET param = 'value' WHERE PAYMENT_TOKEN ='$activateIOPaymentResponse.paymentToken' and PA_FISCAL_CODE='#creditor_institution_code#",
#              "update_noticeid_pa": "UPDATE table_name SET param = 'value' WHERE NOTICE_ID ='311$iuv' and PA_FISCAL_CODE='#creditor_institution_code#'",
#              "update_noticeidrandom_pa": "UPDATE table_name SET param = 'value' WHERE NOTICE_ID ='311011451292109621' and PA_FISCAL_CODE='#creditor_institution_code#'",
#              "noticeid_pa": "SELECT columns FROM table_name WHERE NOTICE_ID = '311$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "transactionid": "SELECT columns FROM table_name WHERE TRANSACTION_ID = '$closePaymentV2.transactionId'"}