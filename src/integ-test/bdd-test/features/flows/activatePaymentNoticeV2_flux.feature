Feature: flux tests for activatePaymentNoticeV2Request

  Background:
    Given systems up

  Scenario: checkPosition
    Given initial json checkPosition
      """
      {
        "positionslist": [
          {
            "fiscalCode": "#creditor_institution_code#",
            "noticeNumber": "310#iuv#"
          },
          {
            "fiscalCode": "#creditor_institution_code#",
            "noticeNumber": "310#iuv1#"
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
      <expirationTime>6000</expirationTime>
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
          "$activatePaymentNoticeV2Response.paymentToken"
        ],
        "outcome": "OK",
        "idPSP": "70000000001",
        "paymentMethod": "TPAY",
        "idBrokerPSP": "70000000001",
        "idChannel": "70000000001_08",
        "transactionId": "#transaction_id#",
        "totalAmount": 12,
        "fee": 0,
        "timestampOperation": "2012-04-23T18:25:43Z",
        "additionalPaymentInformations": {}
      }
      """

  Scenario: sendPaymentOutcomeV2
    Given initial XML sendPaymentOutcomeV2
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
      <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
      </paymentTokens>
      <outcome>OK</outcome>
      <details>
      <paymentMethod>creditCard</paymentMethod>
      <paymentChannel>app</paymentChannel>
      <fee>2.00</fee>
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>name</fullName>
      <streetName>street</streetName>
      <civicNumber>civic</civicNumber>
      <postalCode>postal</postalCode>
      <city>city</city>
      <stateProvinceRegion>state</stateProvinceRegion>
      <country>IT</country>
      <e-mail>prova@test.it</e-mail>
      </payer>
      <applicationDate>2021-12-12</applicationDate>
      <transferDate>2021-12-11</transferDate>
      </details>
      </nod:sendPaymentOutcomeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  # [Activate_blocco_01]
  Scenario: Activate_blocco_01 (parte 1)
    Given initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  Scenario: Activate_blocco_01 (parte 2)
    Given the Activate_blocco_01 (parte 1) scenario executed successfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key_1#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And checks the value 'PAYING',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'PAYING',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_activate on db nodo_online under macro NewMod1

  # [Activate_blocco_05]
  Scenario: Activate_blocco_05 (parte 1)
    Given initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And checks the value 'PAYING',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'PAYING',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_activate on db nodo_online under macro NewMod1

  Scenario: Activate_blocco_05 (parte 2)
    Given the Activate_blocco_05 (parte 1) scenario executed successfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key_1#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv1</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And checks the value 'PAYING',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'PAYING',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_activate on db nodo_online under macro NewMod1

  # [Activate_blocco_02]

  Scenario: [Activate_blocco_02] (part 1)
    Given the checkPosition scenario executed successfully
    And the activatePaymentNoticeV2 scenario executed successfully
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: [Activate_blocco_02] (part 2)
    Given the [Activate_blocco_02] (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: [Activate_blocco_02] (part 3)
    Given the [Activate_blocco_02] (part 2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response

  Scenario: [Activate_blocco_02] (part 4)
    Given the [Activate_blocco_02] (part 3) scenario executed successfully
    And the activatePaymentNoticeV2 scenario executed successfully
    And idempotencyKey with idempotency_key_1 in activatePaymentNoticeV2
    And expirationTime with None in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response1
    And checks the value 'PAYING','PAYMENT_RESERVED','PAYMENT_SENT','PAYMENT_ACCEPTED','PAID','NOTIFIED',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa_token on db nodo_online under macro NewMod1
    And checks the value None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa_token_1 on db nodo_online under macro NewMod1
    And checks the value 'NOTIFIED',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa_token on db nodo_online under macro NewMod1
    And checks the value None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa_token_1 on db nodo_online under macro NewMod1
    And checks the value 'PAYING','PAID','NOTIFIED',None of the record at column STATUS of the table POSITION_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'NOTIFIED',None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_activate on db nodo_online under macro NewMod1

  # [Activate_blocco_03]

  Scenario: [Activate_blocco_03] (part 1)
    Given the checkPosition scenario executed successfully
    And the activatePaymentNoticeV2 scenario executed successfully
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: [Activate_blocco_03] (part 2)
    Given the [Activate_blocco_03] (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: [Activate_blocco_03] (part 3)
    Given the [Activate_blocco_03] (part 2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 20 seconds for expiration

  Scenario: [Activate_blocco_03] (part 4)
    Given the [Activate_blocco_03] (part 3) scenario executed successfully
    And the activatePaymentNoticeV2 scenario executed successfully
    And idempotencyKey with idempotency_key_1 in activatePaymentNoticeV2
    And expirationTime with None in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response1
    And checks the value 'PAYING','PAYMENT_RESERVED','PAYMENT_SENT','PAYMENT_ACCEPTED','PAID','NOTIFIED',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa_token on db nodo_online under macro NewMod1
    And checks the value None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa_token_1 on db nodo_online under macro NewMod1
    And checks the value 'NOTIFIED',None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa_token on db nodo_online under macro NewMod1
    And checks the value None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa_token_1 on db nodo_online under macro NewMod1
    And checks the value 'PAYING','PAID','NOTIFIED',None of the record at column STATUS of the table POSITION_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'NOTIFIED',None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_activate on db nodo_online under macro NewMod1

# da implementare in query_AutomationTest.json:
# "NewMod1" : {"position_activate" : "SELECT columns FROM table_name WHERE NOTICE_ID = '$activatePaymentNoticeV2Request.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNoticeV2Request.fiscalCode'",
#              "notice_id_pa_token" : "SELECT columns FROM table_name WHERE NOTICE_ID = '$activatePaymentNoticeV2Request.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNoticeV2Request.fiscalCode' AND PAYMENT_TOKEN = 'activatePaymentNoticeV2Response.paymentToken'",
#              "notice_id_pa_token_1" : "SELECT columns FROM table_name WHERE NOTICE_ID = '$activatePaymentNoticeV2Request.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNoticeV2Request.fiscalCode' AND PAYMENT_TOKEN = 'activatePaymentNoticeV2Response1.paymentToken'"}