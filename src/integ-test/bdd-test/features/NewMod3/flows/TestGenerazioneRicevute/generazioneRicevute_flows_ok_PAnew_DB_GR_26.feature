Feature: process tests for generazioneRicevute [DB_GR_26] 1325

  Background:
    Given systems up
    


  # Verify phase
  Scenario: Execute verifyPaymentNotice request
      Given initial XML verifyPaymentNotice
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
      <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
      </qrCode>
      <expirationTime>10000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And initial XML paGetPayment
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
      <description>test</description>
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
      <country>DE</country>
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
      <outcome>KO</outcome>
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


  Scenario: Execute second activatePaymentNotice request
    Given the Execute sendPaymentOutcome request scenario executed successfully
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
      <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
      </qrCode>
      <expirationTime>10000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And initial XML paGetPayment
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
      <description>test</description>
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
      <country>DE</country>
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

@runnable
  Scenario: Execute mod3CancelV2 job
    Given the Execute second activatePaymentNotice request scenario executed successfully
    When job mod3CancelV2 triggered after 10 seconds
    Then wait 10 seconds for expiration

    #POSITION_RECEIPT query
    And verify 0 record for the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    #And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns RECEIPT_ID under macro NewMod3 with db name nodo_online
    #And through the query position_receipt retrieve param pr_receipt_id at position 0 and save it under the key pr_receipt_id

    #POSITION_SERVICE query
    And execution query position_service to get value on the table POSITION_SERVICE, with the columns * under macro NewMod3 with db name nodo_online
    And checks the value NotNone of the record at column ID of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And through the query position_service retrieve param ps_id at position 0 and save it under the key ps_id
    And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $verifyPaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value test of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value company of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value office of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And through the query position_service retrieve param ps_debtor_id at position 6 and save it under the key ps_debtor_id
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    
    #POSITION_PAYMENT_PLAN query
    And execution query position_service to get value on the table POSITION_PAYMENT_PLAN, with the columns * under macro NewMod3 with db name nodo_online
    And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $verifyPaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column DUE_DATE of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value None of the record at column RETENTION_DATE of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value 10.00 of the record at column AMOUNT of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value Y of the record at column FLAG_FINAL_PAYMENT of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column METADATA of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And through the query position_service retrieve param ppp_fk_position_service at position 11 and save it under the key ppp_fk_position_service
    
    #POSITION_SUBJECT query
    And execution query position_subject_3 to get value on the table POSITION_SUBJECT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_subject_3 retrieve param psub_id at position 0 and save it under the key psub_id
    And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value G of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value #creditor_institution_code# of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value paGetPaymentName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value paGetPaymentStreet of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value paGetPayment99 of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value 20155 of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value paGetPaymentCity of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value paGetPaymentState of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value DE of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value paGetPayment@test.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3

    #checks
    And check value $ps_debtor_id is equal to value $psub_id
    And check value $ppp_fk_position_service is equal to value $ps_id

   