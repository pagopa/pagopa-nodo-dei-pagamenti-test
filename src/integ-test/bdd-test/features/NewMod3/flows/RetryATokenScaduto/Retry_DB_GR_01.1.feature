Feature: process tests Retry_DB_GR_01.1 1125

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <nod:verifyPaymentNoticeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      </nod:verifyPaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  #activate phase
  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>$verifyPaymentNotice.idPSP</idPSP>
      <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
      <idChannel>$verifyPaymentNotice.idChannel</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>$verifyPaymentNotice.fiscalCode</fiscalCode>
      <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
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

  # test execution
  Scenario: Poller annulli
    Given the activatePaymentNotice request scenario executed successfully
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200

  @runnable
  # Payment Outcome Phase outcome OK
  Scenario: Execute sendPaymentOutcome request
    Given the Poller annulli scenario executed successfully
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>$activatePaymentNotice.idPSP</idPSP>
      <idBrokerPSP>$activatePaymentNotice.idBrokerPSP</idBrokerPSP>
      <idChannel>$activatePaymentNotice.idChannel</idChannel>
      <password>pwdpwdpwd</password>
      <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
      <outcome>OK</outcome>
      <details>
      <paymentMethod>creditCard</paymentMethod>
      <paymentChannel>app</paymentChannel>
      <fee>2.00</fee>
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>John Doe</fullName>
      <streetName>street</streetName>
      <civicNumber>12</civicNumber>
      <postalCode>89020</postalCode>
      <city>city</city>
      <stateProvinceRegion>MI</stateProvinceRegion>
      <country>IT</country>
      <e-mail>john.doe@test.it</e-mail>
      </payer>
      <applicationDate>2021-10-01</applicationDate>
      <transferDate>2021-10-02</transferDate>
      </details>
      </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response
    And wait 5 seconds for expiration
    #POSITION_PAYMENT
    And execution query position_receipt to get value on the table POSITION_PAYMENT, with the columns payment_token,notice_id,pa_fiscal_code,creditor_reference_id,outcome,amount,channel_id,payment_channel,payer_id,payment_method,fee,application_date under macro NewMod3 with db name nodo_online
    And through the query position_receipt retrieve param payment_token at position 0 and save it under the key payment_token
    And through the query position_receipt retrieve param notice_id at position 1 and save it under the key notice_id
    And through the query position_receipt retrieve param pa_fiscal_code at position 2 and save it under the key pa_fiscal_code
    And through the query position_receipt retrieve param creditor_reference_id at position 3 and save it under the key creditor_reference_id
    And through the query position_receipt retrieve param outcome at position 4 and save it under the key outcome
    And through the query position_receipt retrieve param amount at position 5 and save it under the key amount
    And through the query position_receipt retrieve param channel_id at position 6 and save it under the key channel_id
    And through the query position_receipt retrieve param payment_channel at position 7 and save it under the key payment_channel
    And through the query position_receipt retrieve param payer_id at position 8 and save it under the key payer_id
    And through the query position_receipt retrieve param payment_method at position 9 and save it under the key payment_method
    And through the query position_receipt retrieve param fee at position 10 and save it under the key fee
    And through the query position_receipt retrieve param application_date at position 11 and save it under the key application_date
    #POSITION_SERVICE
    And execution query position_receipt to get value on the table POSITION_SERVICE, with the columns description,company_name,office_name,debtor_id under macro NewMod3 with db name nodo_online
    And through the query position_receipt retrieve param description at position 0 and save it under the key description
    And through the query position_receipt retrieve param company_name at position 1 and save it under the key company_name
    And through the query position_receipt retrieve param office_name at position 2 and save it under the key office_name
    And through the query position_receipt retrieve param debtor_id at position 3 and save it under the key debtor_id
    #PSP
    And execution query psp to get value on the table PSP, with the columns ragione_sociale,codice_fiscale,vat_number under macro NewMod3 with db name nodo_cfg
    And through the query psp retrieve param ragione_sociale at position 0 and save it under the key ragione_sociale
    And through the query psp retrieve param codice_fiscale at position 1 and save it under the key codice_fiscale
    And through the query psp retrieve param vat_number at position 2 and save it under the key vat_number
    #DB-CHECK
    And checks the value $payment_token of the record at column receipt_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $notice_id of the record at column notice_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $pa_fiscal_code of the record at column pa_fiscal_code of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $creditor_reference_id of the record at column creditor_reference_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $payment_token of the record at column payment_token of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $amount of the record at column payment_amount of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $description of the record at column description of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $company_name of the record at column company_name of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $office_name of the record at column office_name of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $debtor_id of the record at column debtor_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value #psp# of the record at column psp_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $ragione_sociale of the record at column psp_company_name of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $codice_fiscale of the record at column psp_fiscal_code of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $channel_id of the record at column channel_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $payment_channel of the record at column channel_description of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $payer_id of the record at column payer_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $payment_method of the record at column payment_method of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $fee of the record at column fee of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column payment_date_time of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column transfer_date of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value None of the record at column metadata of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
