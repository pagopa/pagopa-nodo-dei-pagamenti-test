Feature: process tests for Retry_DB_GR_33

  Background:
    Given systems up

  Scenario: initial verifyPaymentNotice
    Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition BROADCAST and where value ('Y') under macro update_query on db nodo_cfg
    And update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with Y, with where condition OBJ_ID and where value ('13','1201') under macro update_query on db nodo_cfg
    And refresh job PA triggered after 10 seconds
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

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    Given the initial verifyPaymentNotice scenario executed successfully
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
      <expirationTime>2000</expirationTime>
      <amount>17.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>responseFull3Transfers</paymentNote>
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
      <transferAmount>10.00</transferAmount>
      <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      <transfer>
      <idTransfer>2</idTransfer>
      <transferAmount>3.00</transferAmount>
      <fiscalCodePA>90000000001</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      <transfer>
      <idTransfer>3</idTransfer>
      <transferAmount>4.00</transferAmount>
      <fiscalCodePA>90000000002</fiscalCodePA>
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
    #And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response

   #Scenario: trigger jobs paSendRt
    #Given the Execute sendPaymentOutcome request scenario executed successfully
    #When job paSendRt triggered after 5 seconds
    #Then verify the HTTP status code of paSendRt response is 200
  @runnable
  Scenario: DB check + db update
    Given the Execute sendPaymentOutcome request scenario executed successfully 
    And verify 3 record for the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
    And update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition OBJ_ID and where value ('13','1201') under macro update_query on db nodo_cfg
    Then refresh job PA triggered after 10 seconds




