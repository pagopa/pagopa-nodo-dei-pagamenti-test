Feature: flux checks for sendPaymentResult

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:verifyPaymentNoticeReq>
      <idPSP>AGID_01</idPSP>
      <idBrokerPSP>97735020584</idBrokerPSP>
      <idChannel>97735020584_03</idChannel>
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
      <idPSP>AGID_01</idPSP>
      <idBrokerPSP>97735020584</idBrokerPSP>
      <idChannel>97735020584_03</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>AGID_01_#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>311$iuv</noticeNumber>
      </qrCode>
      <!--expirationTime>60000</expirationTime-->
      <amount>10.00</amount>
      <paymentNote>responseFull</paymentNote>
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>IOname_#idempotency_key#</fullName>
      <!--Optional:-->
      <streetName>IOstreet</streetName>
      <!--Optional:-->
      <civicNumber>IOcivic</civicNumber>
      <!--Optional:-->
      <postalCode>IOcode</postalCode>
      <!--Optional:-->
      <city>IOcity</city>
      <!--Optional:-->
      <stateProvinceRegion>IOstate</stateProvinceRegion>
      <!--Optional:-->
      <country>DE</country>
      <!--Optional:-->
      <e-mail>IO.test.prova@gmail.com</e-mail>
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
        "identificativoPsp": "70000000001",
        "tipoVersamento": "BPAY",
        "identificativoIntermediario": "70000000001",
        "identificativoCanale": "70000000001_03",
        "pspTransactionId": "resSPR_200OK",
        "totalAmount": 12,
        "fee": 2,
        "timestampOperation": "2033-04-23T18:25:43Z",
        "additionalPaymentInformations": {
          "transactionId": "#transaction_id#",
          "outcomePaymentGateway": "EFF",
          "authorizationCode": "resOK"
        }
      }
      """

  Scenario: sendPaymentOutcome
    Given initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_03</idChannel>
      <password>pwdpwdpwd</password>
      <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
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
      <fullName>SPOname_$activateIOPaymentResponse.paymentToken</fullName>
      <!--Optional:-->
      <streetName>SPOstreet</streetName>
      <!--Optional:-->
      <civicNumber>SPOcivic</civicNumber>
      <!--Optional:-->
      <postalCode>SPOpostal</postalCode>
      <!--Optional:-->
      <city>SPOcity</city>
      <!--Optional:-->
      <stateProvinceRegion>SPOstate</stateProvinceRegion>
      <!--Optional:-->
      <country>IT</country>
      <!--Optional:-->
      <e-mail>SPOprova@test.it</e-mail>
      </payer>
      <applicationDate>2021-12-12</applicationDate>
      <transferDate>2021-12-11</transferDate>
      </details>
      </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  # T_SPR_01

  Scenario: T_SPR_01 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_01 (informazioniPagamento)
    Given the T_SPR_01 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_01 (closePayment)
    Given the T_SPR_01 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  # T_SPR_02

  Scenario: T_SPR_02 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_02 (informazioniPagamento)
    Given the T_SPR_02 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_02 (closePayment)
    Given the T_SPR_02 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And authorizationCode with resTim in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And wait 10 seconds for expiration

  Scenario: T_SPR_02 (sendPaymentOutcome)
    Given the T_SPR_02 (closePayment) scenario executed successfully
    And the sendPaymentOutcome scenario executed successfully
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATE,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,PAID,NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  # T_SPR_03

  Scenario: T_SPR_03 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_03 (informazioniPagamento)
    Given the T_SPR_03 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_03 (closePayment)
    Given the T_SPR_03 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And authorizationCode with resMal in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And wait 20 seconds for expiration

  Scenario: T_SPR_03 (sendPaymentOutcome)
    Given the T_SPR_03 (closePayment) scenario executed successfully
    And the sendPaymentOutcome scenario executed successfully
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATE,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,PAID,NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  # T_SPR_04

  Scenario: T_SPR_04 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_04 (informazioniPagamento)
    Given the T_SPR_04 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_04 (closePayment)
    Given the T_SPR_04 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And authorizationCode with resKO in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  # T_SPR_05

  Scenario: T_SPR_05 (activateIOPayment)
    Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
    And wait 10 seconds for expiration
    And the activateIOPayment scenario executed successfully
    And expirationTime with 10000 in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_05 (informazioniPagamento)
    Given the T_SPR_05 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_05 (closePayment)
    Given the T_SPR_05 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And authorizationCode with resTim in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response

  Scenario: T_SPR_05 (mod3CancelV2)
    Given the T_SPR_05 (closePayment) scenario executed successfully
    When job mod3CancelV2 triggered after 20 seconds
    Then nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
    And wait 10 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  # T_SPR_06

  Scenario: T_SPR_06 (activateIOPayment)
    Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
    And wait 10 seconds for expiration
    And the activateIOPayment scenario executed successfully
    And expirationTime with 10000 in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_06 (informazioniPagamento)
    Given the T_SPR_06 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_06 (closePayment)
    Given the T_SPR_06 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And authorizationCode with resMal in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response

  Scenario: T_SPR_06 (mod3CancelV2)
    Given the T_SPR_06 (closePayment) scenario executed successfully
    When job mod3CancelV2 triggered after 20 seconds
    Then nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
    And wait 10 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  # T_SPR_07

  Scenario: T_SPR_07 (activateIOPayment)
    Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
    And wait 10 seconds for expiration
    And the activateIOPayment scenario executed successfully
    And expirationTime with 10000 in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_07 (informazioniPagamento)
    Given the T_SPR_07 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_07 (closePayment)
    Given the T_SPR_07 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And authorizationCode with resIrr in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response

  Scenario: T_SPR_07 (mod3CancelV2)
    Given the T_SPR_07 (closePayment) scenario executed successfully
    When job mod3CancelV2 triggered after 20 seconds
    Then nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
    And wait 10 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  # T_SPR_08

  Scenario: T_SPR_08 (activateIOPayment)
    Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 1000
    And wait 10 seconds for expiration
    And the activateIOPayment scenario executed successfully
    And expirationTime with 2000 in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_08 (informazioniPagamento)
    Given the T_SPR_08 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_08 (mod3CancelV2)
    Given the T_SPR_08 (informazioniPagamento) scenario executed successfully
    When job mod3CancelV2 triggered after 3 seconds
    Then wait 0 seconds for expiration

  Scenario: T_SPR_08 (closePayment)
    Given the T_SPR_08 (mod3CancelV2) scenario executed successfully
    And the closePayment scenario executed successfully
    And authorizationCode with resOK in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is KO of closePayment response
    And check faultCode is 400 of closePayment response
    And check descrizione is Esito non accettabile a token scaduto
    And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 3600000
    And wait 10 seconds for expiration
    And checks the value PAYING,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  # T_SPR_09

  Scenario: T_SPR_09 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_09 (informazioniPagamento)
    Given the T_SPR_09 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_09 (closePayment)
    Given the T_SPR_09 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And pspTransactionId with resSPR_200KO in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And wait 70 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query token_psptransactionid on db nodo_online under macro AppIO

  # T_SPR_10

  Scenario: T_SPR_10 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_10 (informazioniPagamento)
    Given the T_SPR_10 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_10 (closePayment)
    Given the T_SPR_10 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And pspTransactionId with resSPR_400 in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And wait 70 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 11$iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 77777777777_01 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO

  # T_SPR_11

  Scenario: T_SPR_11 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_11 (informazioniPagamento)
    Given the T_SPR_11 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_11 (closePayment)
    Given the T_SPR_11 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And pspTransactionId with resSPR_404 in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And wait 70 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 11$iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 77777777777_01 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO

  # T_SPR_12

  Scenario: T_SPR_12 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_12 (informazioniPagamento)
    Given the T_SPR_12 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_12 (closePayment)
    Given the T_SPR_12 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And pspTransactionId with resSPR_408 in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And wait 70 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 11$iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 77777777777_01 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO

  # T_SPR_13

  Scenario: T_SPR_13 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_13 (informazioniPagamento)
    Given the T_SPR_13 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_13 (closePayment)
    Given the T_SPR_13 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And pspTransactionId with resSPR_422 in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And wait 70 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 11$iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 77777777777_01 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO











  # T_SPR_14

  Scenario: T_SPR_14 (activateIOPayment)
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And check the value AGID_01 of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO

  Scenario: T_SPR_14 (informazioniPagamento)
    Given the T_SPR_14 (activateIOPayment) scenario executed successfully
    When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: T_SPR_14 (closePayment)
    Given the T_SPR_14 (informazioniPagamento) scenario executed successfully
    And the closePayment scenario executed successfully
    And pspTransactionId with resSPR_400 in closePayment
    When PM sends closePayment to nodo-dei-pagamenti
    Then check esito is OK of closePayment response
    And check faultCode is 200 of closePayment response
    And wait 90 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 11$iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 77777777777_01 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
    And update through the query update_noticeid_iddominio of the table POSITION_RETRY_SENDPAYMENTRESULT the parameter PSP_TRANSACTION_ID with resSPR_200OK under macro AppIO on db nodo_online
    And wait 90 seconds for expiration
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
    And checks the value None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO

# da aggiungere in query_AutomationTest.json
# "AppIO" : {"noticeid_pafiscalcode": "SELECT columns FROM table_name WHERE NOTICE_ID = '311$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' ORDER BY ID ASC",
#            "token_psptransactionid": "SELECT columns FROM table_name WHERE PAYMENT_TOKEN = '$activateIOPaymentResponse.paymentToken' and PSP_TRANSACTION_ID = '$closePayment.pspTransactionId' ORDER BY ID ASC",
#            "noticeid_iddominio": "SELECT columns FROM table_name WHERE NOTICE_ID = '311$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#            "update_noticeid_iddominio": "UPDATE table_name SET param = 'value' WHERE NOTICE_ID ='311$iuv' and ID_DOMINIO = '#creditor_institution_code#'",