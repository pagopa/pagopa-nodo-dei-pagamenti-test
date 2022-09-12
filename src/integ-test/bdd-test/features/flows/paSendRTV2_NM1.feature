Feature: checks for paSendRTV2

  Background:
    Given systems up
    And initial json checkPosition
      """
      {
        "positionslist": [
          {
            "fiscalCode": "#creditor_institution_code#",
            "noticeNumber": "310$iuv"
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
          "$activatePaymentNoticeV2Response.paymentToken"
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
      <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
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

  # PSRTV2_ACTV1_03

  Scenario: PSRTV2_ACTV1_03 (activatePaymentNoticeV2)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with lastPayment0 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_03 (closePaymentV2)
    Given the PSRTV2_ACTV1_03 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_03 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_03 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 3 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAID,NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_04

  Scenario: PSRTV2_ACTV1_04 (activatePaymentNoticeV2)
    Given the activatePaymentNoticeV2 scenario executed successfully
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_04 (closePaymentV2)
    Given the PSRTV2_ACTV1_04 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_04 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_04 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 3 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAID,NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_05

  Scenario: PSRTV2_ACTV1_05 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition FK_PA IN ('6','8') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with responseFull3Transfers in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_05 (closePaymentV2)
    Given the PSRTV2_ACTV1_05 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_05 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_05 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 3 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAID,NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_06

  Scenario: PSRTV2_ACTV1_06 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('13','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with responseFull3Transfers in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_06 (closePaymentV2)
    Given the PSRTV2_ACTV1_06 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_06 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_06 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 5 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('13','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,NOTIFIED,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_07

  Scenario: PSRTV2_ACTV1_07 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('11993','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with responseFull2Transfers in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_07 (closePaymentV2)
    Given the PSRTV2_ACTV1_07 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_07 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_07 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 10 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('11993','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,NOTIFIED,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_08

  Scenario: PSRTV2_ACTV1_08 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('11993','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And amount with 15.00 in activatePaymentNoticeV2
    And paymentNote with mandatory in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_08 (closePaymentV2)
    Given the PSRTV2_ACTV1_08 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 17.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_08 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_08 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 10 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_09

  Scenario: PSRTV2_ACTV1_09 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('11993','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And amount with 15.00 in activatePaymentNoticeV2
    And paymentNote with mandatory in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_09 (closePaymentV2)
    Given the PSRTV2_ACTV1_09 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 17.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_09 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_09 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 10 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('11993', '1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,NOTIFIED,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_10

  Scenario: PSRTV2_ACTV1_10 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And amount with 15.00 in activatePaymentNoticeV2
    And paymentNote with mandatory2 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_10 (closePaymentV2)
    Given the PSRTV2_ACTV1_10 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 17.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_10 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_10 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 10 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_11

  Scenario: PSRTV2_ACTV1_11 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition FK_pa IN ('6') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And amount with 15.00 in activatePaymentNoticeV2
    And paymentNote with mandatory1 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_11 (closePaymentV2)
    Given the PSRTV2_ACTV1_11 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 17.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_11 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_11 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 10 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_12

  Scenario: PSRTV2_ACTV1_12 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_12 (closePaymentV2)
    Given the PSRTV2_ACTV1_12 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_12 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_12 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 10 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_16

  Scenario: PSRTV2_ACTV1_16 (activatePaymentNoticeV2)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And expirationTime with 2000 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_16 (mod3CancelV2)
    Given the PSRTV2_ACTV1_16 (activatePaymentNoticeV2) scenario executed successfully
    When job mod3CancelV2 triggered after 3 seconds
    Then checking the value None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_17

  Scenario: PSRTV2_ACTV1_17 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition FK_PA IN ('6', '8') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And expirationTime with 4000 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_17 (mod3CancelV2)
    Given the PSRTV2_ACTV1_17 (activatePaymentNoticeV2) scenario executed successfully
    When job mod3CancelV2 triggered after 5 seconds
    Then checking the value None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_18

  Scenario: PSRTV2_ACTV1_18 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('13', '1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And expirationTime with 4000 in activatePaymentNoticeV2
    And paymentNote with responseFull3Transfers in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('13', '1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds

  Scenario: PSRTV2_ACTV1_18 (mod3CancelV2)
    Given the PSRTV2_ACTV1_18 (activatePaymentNoticeV2) scenario executed successfully
    When job mod3CancelV2 triggered after 0 seconds
    Then checking the value None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_20

  Scenario: PSRTV2_ACTV1_20 (activatePaymentNoticeV2)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with lastPayment0 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_20 (closePaymentV2)
    Given the PSRTV2_ACTV1_20 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 18.00 in closePaymentV2
    And fee with 8.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_20 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_20 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    And fee with 8.00 in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 70 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAID,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAID,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_21

  Scenario: PSRTV2_ACTV1_21 (activatePaymentNoticeV2)
    Given the activatePaymentNoticeV2 scenario executed successfully
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_21 (closePaymentV2)
    Given the PSRTV2_ACTV1_21 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 18.00 in closePaymentV2
    And fee with 8.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_21 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_21 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    And fee with 8.00 in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 100 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAID,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAID,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_22

  Scenario: PSRTV2_ACTV1_22 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition FK_PA IN ('6','8') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with responseFull3Transfers in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_22 (closePaymentV2)
    Given the PSRTV2_ACTV1_22 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 18.00 in closePaymentV2
    And fee with 8.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_22 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_22 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    And fee with 8.00 in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 100 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_23

  Scenario: PSRTV2_ACTV1_23 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('13','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with responseFull3Transfers in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_23 (closePaymentV2)
    Given the PSRTV2_ACTV1_23 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 14.00 in closePaymentV2
    And fee with 4.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_23 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_23 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    And fee with 4.00 in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 100 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('13','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_PENDING,NOTIFIED,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAID,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAID,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_24

  # Imposta una response Timeout per la paSendRT delle PA secondarie
  # Imposta VERSIONE_PRIMITIVE = 2 per le stazioni secondarie con OBJ_ID = 11990 e OBJ_ID = 181

  Scenario: PSRTV2_ACTV1_24 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('11993','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with responseFull2Transfers in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_24 (closePaymentV2)
    Given the PSRTV2_ACTV1_24 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_24 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_24 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 70 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('11993','1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' AND RECIPIENT_STATION_ID = '#creditor_institution_code#_08' on db nodo_online under macro generic_queries
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' AND RECIPIENT_STATION_ID = '90000000001_06' on db nodo_online under macro generic_queries
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' AND RECIPIENT_STATION_ID = '90000000001_09' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,NOTICE_PENDING,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAID,NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,NotNone,None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value $activatePaymentNoticeV2Response.paymentToken,$activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value 1,1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_25

  # Imposta una response Timeout per la paSendRT delle PA secondarie
  # Imposta VERSIONE_PRIMITIVE = 2 per la stazione secondaria con OBJ_ID = 181

  Scenario: PSRTV2_ACTV1_25 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And amount with 15.00 in activatePaymentNoticeV2
    And paymentNote with mandatory in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_25 (closePaymentV2)
    Given the PSRTV2_ACTV1_25 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 17.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_25 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_25 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 70 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_26

  Scenario: PSRTV2_ACTV1_26 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with Y with where condition OBJ_ID IN ('1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And amount with 15.00 in activatePaymentNoticeV2
    And paymentNote with mandatory in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_26 (closePaymentV2)
    Given the PSRTV2_ACTV1_26 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 19.00 in closePaymentV2
    And fee with 4.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_26 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_26 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    And fee with 4.00 in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 100 seconds for expiration
    And updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition OBJ_ID IN ('1201') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And checking the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_PENDING,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAID,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAID,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_27

  Scenario: PSRTV2_ACTV1_27 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition FK_PA IN ('6') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And amount with 15.00 in activatePaymentNoticeV2
    And paymentNote with mandatory1 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_27 (closePaymentV2)
    Given the PSRTV2_ACTV1_27 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 19.00 in closePaymentV2
    And fee with 4.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_27 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_27 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    And fee with 4.00 in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 100 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_28

  Scenario: PSRTV2_ACTV1_28 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition FK_PA IN ('6', '8') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with responseFull3Transfers in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_28 (closePaymentV2)
    Given the PSRTV2_ACTV1_28 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_28 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_28 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 100 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_SENT,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAID,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAID,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone,None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

    # Imposta la response OK per la paSendRT della PA intestataria entro i 5 retry

    And wait 65 seconds for expiration
    And checking the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTICE_PENDING,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value NOTIFIED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_29

  Scenario: PSRTV2_ACTV1_29 (activatePaymentNoticeV2)
    Given updating through the query generic_update of the table PA_STAZIONE_PA the parameter BROADCAST with N with where condition FK_PA IN ('6', '8') under macro generic_queries on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And updating through the query generic_update of the table CONFIGURATION_KEYS the parameter CONFIG_VALUE with 1000 with where condition CONFIG_KEY ='default_durata_estensione_token_IO' under macro generic_queries on db nodo_cfg
    And refresh job CONFIG triggered after 10 seconds
    And the activatePaymentNoticeV2 scenario executed successfully
    And expirationTime with 2000 in activatePaymentNoticeV2
    And amount with 3.00 in activatePaymentNoticeV2
    And paymentNote with responseFull3Transfers300 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_29 (closePaymentV2)
    Given the PSRTV2_ACTV1_29 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    And totalAmount with 5.00 in closePaymentV2
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 25 seconds for expiration

  Scenario: PSRTV2_ACTV1_29 (mod3CancelV2)
    Given the PSRTV2_ACTV1_29 (closePaymentV2) scenario executed successfully
    When job mod3CancelV2 triggered after 0 seconds
    Then wait 10 seconds for expiration

  Scenario: PSRTV2_ACTV1_29 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_29 (mod3CancelV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And updating through the query generic_update of the table CONFIGURATION_KEYS the parameter CONFIG_VALUE with 3600000 with where condition CONFIG_KEY ='default_durata_estensione_token_IO' under macro generic_queries on db nodo_cfg
    And refresh job CONFIG triggered after 10 seconds
    And checking the value None of the record at column ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value None of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries
    And checking the value None of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' on db nodo_online under macro generic_queries

  # PSRTV2_ACTV1_30

  Scenario: PSRTV2_ACTV1_30 (activatePaymentNoticeV2)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with metadati in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_30 (closePaymentV2)
    Given the PSRTV2_ACTV1_30 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_30 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_30 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response

  # Verifica che nella request della paSendRTV2 sia presente il metadato CHIAVEOK nella transferList

  # DB check: metadato CHIAVEOK contenuto nel record selezionato dalla query SELECT METADATA FROM POSITION_TRANSFER WHERE NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#'

  # PSRTV2_ACTV1_31

  Scenario: PSRTV2_ACTV1_31 (activatePaymentNoticeV2)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And paymentNote with metadati99 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: PSRTV2_ACTV1_31 (closePaymentV2)
    Given the PSRTV2_ACTV1_31 (activatePaymentNoticeV2) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 5 seconds for expiration

  Scenario: PSRTV2_ACTV1_31 (sendPaymentOutcomeV2)
    Given the PSRTV2_ACTV1_31 (closePaymentV2) scenario executed successfully
    And the sendPaymentOutcomeV2 scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response

# Verifica che nella request della paSendRTV2 sia presente il metadato CHIAVESCONOSCIUTA nella transferList

# DB check: metadato CHIAVESCONOSCIUTA contenuto nel record selezionato dalla query SELECT METADATA FROM POSITION_TRANSFER WHERE NOTICE_ID = '310$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#'