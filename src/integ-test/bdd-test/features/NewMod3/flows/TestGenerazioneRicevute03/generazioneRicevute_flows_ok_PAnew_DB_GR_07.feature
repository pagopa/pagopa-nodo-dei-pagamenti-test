Feature: process tests for generazioneRicevute [DB_GR_07]

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
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
    And EC new version

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response


  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    Given initial XML paGetPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paGetPaymentRes>
      <outcome>OK</outcome>
      <data>
      <creditorReferenceId>$iuv</creditorReferenceId>
      <paymentAmount>10.00</paymentAmount>
      <dueDate>2021-12-31</dueDate>
      <!--Optional:-->
      <retentionDate>2021-12-31T12:12:12</retentionDate>
      <!--Optional:-->
      <lastPayment>1</lastPayment>
      <description>description</description>
      <!--Optional:-->
      <companyName>company</companyName>
      <!--Optional:-->
      <officeName>office</officeName>
      <debtor>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>paGetPaymentName</fullName>
      <!--Optional:-->
      <streetName>paGetPaymentStreet</streetName>
      <!--Optional:-->
      <civicNumber>paGetPayment99</civicNumber>
      <!--Optional:-->
      <postalCode>20155</postalCode>
      <!--Optional:-->
      <city>paGetPaymentCity</city>
      <!--Optional:-->
      <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
      <!--Optional:-->
      <country>IT</country>
      <!--Optional:-->
      <e-mail>paGetPayment@test.it</e-mail>
      </debtor>
      <!--Optional:-->
      <transferList>
      <!--1 to 5 repetitions:-->
      <transfer>
      <idTransfer>1</idTransfer>
      <transferAmount>10.00</transferAmount>
      <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      </transferList>
      <!--Optional:-->
      <metadata>
      <!--1 to 10 repetitions:-->
      <mapEntry>
      <key>1</key>
      <value>22</value>
      </mapEntry>
      </metadata>
      </data>
      </paf:paGetPaymentRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Payment Outcome Phase outcome OK
  Scenario: Execute sendPaymentOutcome request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
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
      <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
    Then check outcome is OK of sendPaymentOutcome response
    And wait 5 seconds for expiration
    #POSITION_RECEIPT_RECIPIENT query
    And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
    And execution query position_receipt_recipient to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt_recipient retrieve param pa_fiscal_code at position 1 and save it under the key pa_fiscal_code
    And through the query position_receipt_recipient retrieve param notice_id at position 2 and save it under the key notice_id
    And through the query position_receipt_recipient retrieve param creditor_reference_id at position 3 and save it under the key creditor_reference_id
    And through the query position_receipt_recipient retrieve param payment_token at position 4 and save it under the key payment_token
    And through the query position_receipt_recipient retrieve param recipient_pa_fiscal_code at position 5 and save it under the key recipient_pa_fiscal_code
    And through the query position_receipt_recipient retrieve param recipient_broker_pa_id at position 6 and save it under the key recipient_broker_pa_id
    And through the query position_receipt_recipient retrieve param recipient_station_id at position 7 and save it under the key recipient_station_id
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
    And through the query position_receipt_recipient retrieve param fk_position_receipt at position 11 and save it under the key fk_position_receipt
    #POSITION_PAYMENT query
    And execution query payment_status to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query payment_status retrieve param pp_pa_fiscal_code at position 1 and save it under the key pp_pa_fiscal_code
    And through the query payment_status retrieve param pp_notice_id at position 2 and save it under the key pp_notice_id
    And through the query payment_status retrieve param pp_creditor_reference_id at position 3 and save it under the key pp_creditor_reference_id
    And through the query payment_status retrieve param pp_payment_token at position 4 and save it under the key pp_payment_token
    And through the query payment_status retrieve param pp_broker_pa_id at position 5 and save it under the key pp_broker_pa_id
    And through the query payment_status retrieve param pp_station_id at position 6 and save it under the key pp_station_id
    #POSITION_RECEIPT query
    And execution query payment_status to get value on the table POSITION_RECEIPT, with the columns ID under macro NewMod3 with db name nodo_online
    And through the query payment_status retrieve param pr_id at position 0 and save it under the key pr_id
    #checks
    And check value $pa_fiscal_code is equal to value $pp_pa_fiscal_code
    And check value $notice_id is equal to value $pp_notice_id
    And check value $creditor_reference_id is equal to value $pp_creditor_reference_id
    And check value $payment_token is equal to value $pp_payment_token
    And check value $recipient_pa_fiscal_code is equal to value $pp_pa_fiscal_code
    And check value $recipient_broker_pa_id is equal to value $pp_broker_pa_id
    And check value $recipient_station_id is equal to value $pp_station_id
    And check value $fk_position_receipt is equal to value $pr_id

    #POSITION_RECEIPT_RECIPIENT_STATUS query
    #POSITION_RECEIPT_RECIPIENT query
    #POSITION_RECEIPT_XML query
    #POSITION_PAYMENT query
    #POSITION_RECEIPT query
    #POSITION_RECEIPT_RECIPIENT query
    #POSITION_RECEIPT_XML query
