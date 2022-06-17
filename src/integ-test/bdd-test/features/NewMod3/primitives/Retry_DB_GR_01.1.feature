Feature: process tests Retry_DB_GR_01.1

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <nod:verifyPaymentNoticeReq>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      </nod:verifyPaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC new version

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  #activate phase
  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>2000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  #sleep phase1
  Scenario: Execute sleep phase1
    Given the Execute activatePaymentNotice request scenario executed successfully
    And PSP waits expirationTime of activatePaymentNotice expires

  # test execution
  Scenario: Execution test
    Given the activatePaymentNoticeReq request scenario executed successfully
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200


  # Payment Outcome Phase outcome OK
  Scenario: Execute sendPaymentOutcome request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>${psp}</idPSP>
      <idBrokerPSP>${intermediarioPSP}</idBrokerPSP>
      <idChannel>${canale3}</idChannel>
      <password>${password}</password>
      <paymentToken>${#TestCase#token}</paymentToken>
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
      </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """

    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    #Test1
    Then check outcome is OK of sendPaymentOutcome response
    #sleep phase2
    And wait 2.2 second for expiration
    And the value id, is same as null, of the record at column ID of the table POSITION_RECEIPT retrivied by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.pa_fiscal_code of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.creditor_reference_id of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query position_subject on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.payment_token of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.payment_amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.company_name of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.office_name of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.debitor_id of the record at column DEBITOR_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.psp_id of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.psp_fiscal_code of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.psp_vat_number of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.psp_company_name of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.channel_id of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.channel_description of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.payer_id of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And the value payment_date_time, is different from null, of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrivied by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.application_date of the record at column FEE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And the value transfer_date, is different from null, of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrivied by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.metadata of the record at column METADATA of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And the value rt_id, is different from null, of the record at column RT_ID of the table POSITION_SUBJECT retrivied by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.fk_position_payment of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And the value rt_id, is same as null, of the record at column RT_ID of the table POSITION_SUBJECT retrivied by the query position_receipt on db nodo_online under macro NewMod3





