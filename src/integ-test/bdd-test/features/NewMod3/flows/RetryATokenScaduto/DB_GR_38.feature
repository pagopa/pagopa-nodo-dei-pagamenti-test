Feature: process tests for DB_GR_38

  Background:
    Given systems up

  Scenario: Execute verifyPaymentNotice request
    Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition BROADCAST and where value ('Y') under macro update_query on db nodo_cfg
    And refresh job PA triggered after 10 seconds
    And wait 5 seconds for expiration
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
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
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
      <expirationTime>6000</expirationTime>
      <amount>17.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>mandatory1</paymentNote>
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
      <paymentAmount>17.00</paymentAmount>
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
      <transferAmount>17.00</transferAmount>
      <fiscalCodePA>90000000001</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
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

  #Scenario: Poller Annulli
    #Given the Execute activatePaymentNotice request scenario executed successfully
    #When job mod3CancelV2 triggered after 3 seconds
    #Then verify the HTTP status code of mod3CancelV2 response is 200

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
    Then check outcome is OK of sendPaymentOutcome response
    

   Scenario: trigger jobs paSendRt
    Given the Execute sendPaymentOutcome request scenario executed successfully
    When job paSendRt triggered after 5 seconds
    Then verify the HTTP status code of paSendRt response is 200

  @runnable
  Scenario: DB check + db update
    Given the trigger jobs paSendRt scenario executed successfully
    And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And execution query position_receipt_recipient_status to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt_recipient_status retrieve param pa_fiscal_code at position 1 and save it under the key pa_fiscal_code
    And through the query position_receipt_recipient_status retrieve param notice_id at position 2 and save it under the key notice_id
    And through the query position_receipt_recipient_status retrieve param creditor_reference_id at position 3 and save it under the key creditor_reference_id
    And through the query position_receipt_recipient_status retrieve param payment_token at position 4 and save it under the key payment_token
    And through the query position_receipt_recipient_status retrieve param recipient_pa_fiscal_code at position 5 and save it under the key recipient_pa_fiscal_code
    And through the query position_receipt_recipient_status retrieve param recipient_broker_pa_id at position 6 and save it under the key recipient_broker_pa_id
    And through the query position_receipt_recipient_status retrieve param recipient_station_id at position 7 and save it under the key recipient_station_id
    And through the query position_receipt_recipient_status retrieve param status at position 8 and save it under the key status
    And through the query position_receipt_recipient_status retrieve param fk_position_receipt at position 11 and save it under the key fk_position_receipt
    And checks the value $pa_fiscal_code of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $notice_id of the record at column NOTICE_ID of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $creditor_reference_id of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $payment_token of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $recipient_pa_fiscal_code of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $recipient_broker_pa_id of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $recipient_station_id of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $fk_position_receipt of the record at column ID of the table POSITION_RECEIPT retrived by the query position_status_n on db nodo_online under macro NewMod3
    # DB Check POSITION_RECEIPT_RECIPIENT_STATUS
    And execution query position_receipt_recipient_status to get value on the table POSITION_RECEIPT_RECIPIENT_STATUS, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt_recipient_status retrieve param 1pa_fiscal_code at position 1 and save it under the key 1pa_fiscal_code
    And through the query position_receipt_recipient_status retrieve param 1notice_id at position 2 and save it under the key 1notice_id
    And through the query position_receipt_recipient_status retrieve param 1creditor_reference_id at position 3 and save it under the key 1creditor_reference_id
    And through the query position_receipt_recipient_status retrieve param 1payment_token at position 4 and save it under the key 1payment_token
    And through the query position_receipt_recipient_status retrieve param 1recipient_pa_fiscal_code at position 5 and save it under the key 1recipient_pa_fiscal_code
    And through the query position_receipt_recipient_status retrieve param 1recipient_broker_pa_id at position 6 and save it under the key 1recipient_broker_pa_id
    And through the query position_receipt_recipient_status retrieve param 1recipient_station_id at position 7 and save it under the key 1recipient_station_id
    And through the query position_receipt_recipient_status retrieve param 1status at position 8 and save it under the key 1status
    And through the query position_receipt_recipient_status retrieve param 1fk_position_receipt_recipient at position 10 and save it under the key 1fk_position_receipt_recipient
    And checks the value $1pa_fiscal_code of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $1notice_id of the record at column NOTICE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $1creditor_reference_id of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $1payment_token of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $1recipient_pa_fiscal_code of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $1recipient_broker_pa_id of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $1recipient_station_id of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $1fk_position_receipt_recipient of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $recipient_station_id of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value NOTICE_GENERATED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
  
  
  




