Feature: process tests for generazioneRicevute 1315

  Background:
    Given systems up

    # Verify phase
  Scenario: Execute verifyPaymentNotice request
    Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
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
      <noticeNumber>$1noticeNumber</noticeNumber>
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
      <noticeNumber>$1noticeNumber</noticeNumber>
      </qrCode>
      <expirationTime>120000</expirationTime>
      <amount>70.00</amount>
      <dueDate>2021-12-31</dueDate>
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
      <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
      <paymentAmount>70.00</paymentAmount>
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
      <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
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
      <transferAmount>70.00</transferAmount>
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

  # Payment Outcome Phase outcome OK with paymentchannel
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
    
    #db check1
    #And check DB_GR_01
    And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt retrieve param id at position 0 and save it under the key id
    And through the query position_receipt retrieve param receipt_id at position 1 and save it under the key receipt_id
    And through the query position_receipt retrieve param notice_id at position 2 and save it under the key notice_id
    And through the query position_receipt retrieve param pa_fiscal_code at position 3 and save it under the key pa_fiscal_code
    And through the query position_receipt retrieve param creditor_reference_id at position 4 and save it under the key creditor_reference_id
    And through the query position_receipt retrieve param payment_token at position 5 and save it under the key payment_token
    And through the query position_receipt retrieve param outcome at position 6 and save it under the key outcome
    And through the query position_receipt retrieve param paymentAmount at position 7 and save it under the key paymentAmount
    And through the query position_receipt retrieve param description at position 8 and save it under the key description
    And through the query position_receipt retrieve param companyName at position 9 and save it under the key companyName
    And through the query position_receipt retrieve param officeName at position 10 and save it under the key officeName
    And through the query position_receipt retrieve param debtorID at position 11 and save it under the key debtorID
    And through the query position_receipt retrieve param pspID at position 12 and save it under the key pspID
    And through the query position_receipt retrieve param psp_fiscal_code at position 13 and save it under the key psp_fiscal_code
    And through the query position_receipt retrieve param psp_vat_number at position 14 and save it under the key psp_vat_number
    And through the query position_receipt retrieve param psp_company_name at position 15 and save it under the key psp_company_name
    And through the query position_receipt retrieve param channelID at position 16 and save it under the key channelID
    And through the query position_receipt retrieve param channelDescription at position 17 and save it under the key channelDescription
    And through the query position_receipt retrieve param payerID at position 18 and save it under the key payerID
    And through the query position_receipt retrieve param paymentMethod at position 19 and save it under the key paymentMethod
    And through the query position_receipt retrieve param fee at position 20 and save it under the key fee
    And through the query position_receipt retrieve param paymentDateTime at position 21 and save it under the key paymentDateTime
    #And through the query position_receipt retrieve param applicationDate at position 22 and save it under the key applicationDate
    #And through the query position_receipt retrieve param transferDate at position 23 and save it under the key transferDate
    And through the query position_receipt retrieve param metadata at position 24 and save it under the key metadata
    And through the query position_receipt retrieve param rtID at position 25 and save it under the key rtID
    And through the query position_receipt retrieve param fk_position_payment at position 26 and save it under the key fk_position_payment

    And checks the value #psp# of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query position_payment on db nodo_online under macro NewMod3

    And checks the value $receipt_id of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $notice_id of the record at column NOTICE_ID of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $pa_fiscal_code of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $creditor_reference_id of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $paymentAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $channelID of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $channelDescription of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $payerID of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $fk_position_payment of the record at column ID of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    #And checks the value $applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $description of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $companyName of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $officeName of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $debtorID of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3

    #And checks the value $metadata of the record at column METADATA of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3

    And checks the value $psp_company_name of the record at column RAGIONE_SOCIALE of the table PSP retrived by the query psp on db nodo_cfg under macro NewMod3
    And checks the value $psp_fiscal_code of the record at column CODICE_FISCALE of the table PSP retrived by the query psp on db nodo_cfg under macro NewMod3
    #And checks the value $psp_vat_number of the record at column VAT_NUMBER of the table PSP retrived by the query psp on db nodo_cfg under macro NewMod3


  Scenario: Execute second verifyPaymentNotice request
    Given the Execute sendPaymentOutcome request scenario executed successfully
    And generate 2 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
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
      <noticeNumber>$2noticeNumber</noticeNumber>
      </qrCode>
      </nod:verifyPaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  Scenario: Execute second activatePaymentNotice request
    Given the Execute second verifyPaymentNotice request scenario executed successfully
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
      <noticeNumber>$2noticeNumber</noticeNumber>
      </qrCode>
      <expirationTime>120000</expirationTime>
      <amount>70.00</amount>
      <dueDate>2021-12-31</dueDate>
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
      <creditorReferenceId>#cod_segr#$2iuv</creditorReferenceId>
      <paymentAmount>70.00</paymentAmount>
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
      <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
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
      <transferAmount>70.00</transferAmount>
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
  # Payment Outcome Phase outcome OK without paymentchannel
  Scenario: Execute sendPaymentOutcome request
    Given the Execute second activatePaymentNotice request scenario executed successfully
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











