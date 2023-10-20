Feature: process tests for generazioneRicevute [DB_GR_18]

  Background:
    Given systems up
    And EC new version


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
    And EC new version
    # set broadcast=true
    And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'Y', with where condition OBJ_ID = '11993' under macro update_query on db nodo_cfg
    And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'Y', with where condition OBJ_ID = '1201' under macro update_query on db nodo_cfg
    When refresh job ALL triggered after 10 seconds
    And wait 15 seconds for expiration
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
      <expirationTime>60000</expirationTime>
      <amount>15.00</amount>
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
      <paymentAmount>15.00</paymentAmount>
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
      <transferAmount>5.00</transferAmount>
      <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      <transfer>
      <idTransfer>2</idTransfer>
      <transferAmount>5.00</transferAmount>
      <fiscalCodePA>90000000001</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      <transfer>
      <idTransfer>3</idTransfer>
      <transferAmount>5.00</transferAmount>
      <fiscalCodePA>90000000001</fiscalCodePA>
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

@runnable @dependentwrite @lazy @dependentwrite
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

    # set broadcast=false
    #And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'N', with where condition OBJ_ID = '$broadcast_id' under macro update_query on db nodo_cfg
    And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'N', with where condition OBJ_ID = '11993' under macro update_query on db nodo_cfg
    And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'N', with where condition OBJ_ID = '1201' under macro update_query on db nodo_cfg
    And refresh job ALL triggered after 10 seconds

    And wait 10 seconds for expiration
    #POSITION_RECEIPT_RECIPIENT query
    And replace paStationId content with #id_station# content
    And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And execution query position_receipt_recipient_2pa to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt_recipient_2pa retrieve param pa_fiscal_code at position 1 and save it under the key pa_fiscal_code
    And through the query position_receipt_recipient_2pa retrieve param notice_id at position 2 and save it under the key notice_id
    And through the query position_receipt_recipient_2pa retrieve param creditor_reference_id at position 3 and save it under the key creditor_reference_id
    And through the query position_receipt_recipient_2pa retrieve param payment_token at position 4 and save it under the key payment_token
    And through the query position_receipt_recipient_2pa retrieve param recipient_pa_fiscal_code at position 5 and save it under the key recipient_pa_fiscal_code
    And through the query position_receipt_recipient_2pa retrieve param recipient_broker_pa_id at position 6 and save it under the key recipient_broker_pa_id
    And through the query position_receipt_recipient_2pa retrieve param recipient_station_id at position 7 and save it under the key recipient_station_id
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And through the query position_receipt_recipient_2pa retrieve param fk_position_receipt at position 11 and save it under the key fk_position_receipt
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

    #POSITION_RECEIPT_RECIPIENT paSecondaria1 query
    And replace paStationId content with 90000000001_06 content
    And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And execution query position_receipt_recipient_2pa to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt_recipient_2pa retrieve param prr2pa1_pa_fiscal_code at position 1 and save it under the key prr2pa1_pa_fiscal_code
    And through the query position_receipt_recipient_2pa retrieve param prr2pa1_notice_id at position 2 and save it under the key prr2pa1_notice_id
    And through the query position_receipt_recipient_2pa retrieve param prr2pa1_creditor_reference_id at position 3 and save it under the key prr2pa1_creditor_reference_id
    And through the query position_receipt_recipient_2pa retrieve param prr2pa1_payment_token at position 4 and save it under the key prr2pa1_payment_token
    And checks the value 90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value 90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value 90000000001_06 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And through the query position_receipt_recipient_2pa retrieve param prr2pa1_recipient_broker_pa_id at position 6 and save it under the key prr2pa1_recipient_broker_pa_id
    And through the query position_receipt_recipient_2pa retrieve param prr2pa1_recipient_station_id at position 7 and save it under the key prr2pa1_recipient_station_id
    #And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And through the query position_receipt_recipient_2pa retrieve param prr2pa1_fk_position_receipt at position 11 and save it under the key prr2pa1_fk_position_receipt
    #checks
    And check value $prr2pa1_pa_fiscal_code is equal to value $pp_pa_fiscal_code
    And check value $prr2pa1_notice_id is equal to value $pp_notice_id
    And check value $prr2pa1_creditor_reference_id is equal to value $pp_creditor_reference_id
    And check value $prr2pa1_payment_token is equal to value $pp_payment_token
    And check value $prr2pa1_fk_position_receipt is equal to value $pr_id

    #POSITION_RECEIPT_RECIPIENT paSecondaria2 query
    And replace paStationId content with 90000000001_09 content
    And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And execution query position_receipt_recipient_2pa to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt_recipient_2pa retrieve param prr2pa2_pa_fiscal_code at position 1 and save it under the key prr2pa2_pa_fiscal_code
    And through the query position_receipt_recipient_2pa retrieve param prr2pa2_notice_id at position 2 and save it under the key prr2pa2_notice_id
    And through the query position_receipt_recipient_2pa retrieve param prr2pa2_creditor_reference_id at position 3 and save it under the key prr2pa2_creditor_reference_id
    And through the query position_receipt_recipient_2pa retrieve param prr2pa2_payment_token at position 4 and save it under the key prr2pa2_payment_token
    And checks the value 90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value 90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value 90000000001_09 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And through the query position_receipt_recipient_2pa retrieve param prr2pa2_recipient_broker_pa_id at position 6 and save it under the key prr2pa2_recipient_broker_pa_id
    And through the query position_receipt_recipient_2pa retrieve param prr2pa2_recipient_station_id at position 7 and save it under the key prr2pa2_recipient_station_id
    #And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And through the query position_receipt_recipient_2pa retrieve param prr2pa2_fk_position_receipt at position 11 and save it under the key prr2pa2_fk_position_receipt
    #checks
    And check value $prr2pa2_pa_fiscal_code is equal to value $pp_pa_fiscal_code
    And check value $prr2pa2_notice_id is equal to value $pp_notice_id
    And check value $prr2pa2_creditor_reference_id is equal to value $pp_creditor_reference_id
    And check value $prr2pa2_payment_token is equal to value $pp_payment_token
    And check value $prr2pa2_fk_position_receipt is equal to value $pr_id


    #POSITION_RECEIPT_RECIPIENT_STATUS query
    And checks the value NOTICE_GENERATED, NOTICE_SENT, NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3

    #POSITION_RECEIPT_RECIPIENT query
    And replace paStationId content with #id_station# content
    And execution query position_receipt_recipient_2pa to get value on the table POSITION_RECEIPT_XML, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt_recipient_2pa retrieve param prx_pa_fiscal_code at position 1 and save it under the key prx_pa_fiscal_code
    And through the query position_receipt_recipient_2pa retrieve param prx_notice_id at position 2 and save it under the key prx_notice_id
    And through the query position_receipt_recipient_2pa retrieve param prx_creditor_reference_id at position 3 and save it under the key prx_creditor_reference_id
    And through the query position_receipt_recipient_2pa retrieve param prx_payment_token at position 4 and save it under the key prx_payment_token
    And through the query position_receipt_recipient_2pa retrieve param prx_recipient_pa_fiscal_code at position 8 and save it under the key prx_recipient_pa_fiscal_code
    And through the query position_receipt_recipient_2pa retrieve param prx_recipient_broker_pa_id at position 9 and save it under the key prx_recipient_broker_pa_id
    And through the query position_receipt_recipient_2pa retrieve param prx_recipient_station_id at position 10 and save it under the key prx_recipient_station_id
    And through the query position_receipt_recipient_2pa retrieve param prx_fk_position_receipt at position 7 and save it under the key prx_fk_position_receipt
    And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    #checks
    And check value $prx_pa_fiscal_code is equal to value $pp_pa_fiscal_code
    And check value $prx_notice_id is equal to value $pp_notice_id
    And check value $prx_creditor_reference_id is equal to value $pp_creditor_reference_id
    And check value $prx_payment_token is equal to value $pp_payment_token
    And check value $prx_recipient_pa_fiscal_code is equal to value $recipient_pa_fiscal_code
    And check value $prx_recipient_broker_pa_id is equal to value $recipient_broker_pa_id
    And check value $prx_recipient_station_id is equal to value $recipient_station_id
    And check value $prx_fk_position_receipt is equal to value $pr_id

    #POSITION_RECEIPT_RECIPIENT paSecondaria1 query
    And replace paStationId content with 90000000001_06 content
    And execution query position_receipt_recipient_2pa to get value on the table POSITION_RECEIPT_XML, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt_recipient_2pa retrieve param prxpa1_pa_fiscal_code at position 1 and save it under the key prxpa1_pa_fiscal_code
    And through the query position_receipt_recipient_2pa retrieve param prxpa1_notice_id at position 2 and save it under the key prxpa1_notice_id
    And through the query position_receipt_recipient_2pa retrieve param prxpa1_creditor_reference_id at position 3 and save it under the key prxpa1_creditor_reference_id
    And through the query position_receipt_recipient_2pa retrieve param prxpa1_payment_token at position 4 and save it under the key prxpa1_payment_token
    And checks the value 90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value 90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value 90000000001_06 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And through the query position_receipt_recipient_2pa retrieve param prxpa1_fk_position_receipt at position 7 and save it under the key prxpa1_fk_position_receipt
    And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    #checks
    And check value $prxpa1_pa_fiscal_code is equal to value $pp_pa_fiscal_code
    And check value $prxpa1_notice_id is equal to value $pp_notice_id
    And check value $prxpa1_creditor_reference_id is equal to value $pp_creditor_reference_id
    And check value $prxpa1_payment_token is equal to value $pp_payment_token
    And check value $prxpa1_fk_position_receipt is equal to value $pr_id

    #POSITION_RECEIPT_RECIPIENT paSecondaria2 query
    And replace paStationId content with 90000000001_09 content
    And execution query position_receipt_recipient_2pa to get value on the table POSITION_RECEIPT_XML, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_receipt_recipient_2pa retrieve param prxpa2_pa_fiscal_code at position 1 and save it under the key prxpa2_pa_fiscal_code
    And through the query position_receipt_recipient_2pa retrieve param prxpa2_notice_id at position 2 and save it under the key prxpa2_notice_id
    And through the query position_receipt_recipient_2pa retrieve param prxpa2_creditor_reference_id at position 3 and save it under the key prxpa2_creditor_reference_id
    And through the query position_receipt_recipient_2pa retrieve param prxpa2_payment_token at position 4 and save it under the key prxpa2_payment_token
    And checks the value 90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value 90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value 90000000001_09 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And through the query position_receipt_recipient_2pa retrieve param prxpa2_fk_position_receipt at position 7 and save it under the key prxpa2_fk_position_receipt
    And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient_2pa on db nodo_online under macro NewMod3
    #checks
    And check value $prxpa2_pa_fiscal_code is equal to value $pp_pa_fiscal_code
    And check value $prxpa2_notice_id is equal to value $pp_notice_id
    And check value $prxpa2_creditor_reference_id is equal to value $pp_creditor_reference_id
    And check value $prxpa2_payment_token is equal to value $pp_payment_token
    And check value $prxpa2_fk_position_receipt is equal to value $pr_id

    #POSITION_RECEIPT_XML query
    And replace paStationId content with #id_station# content
    And execution query get_receipt_xml_station to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
    And through the query get_receipt_xml_station retrieve xml prx_xml at position 0 and save it under the key prx_xml
    #POSITION_PAYMENT query
    And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query payment_status_pay retrieve param pp1_broker_pa_id at position 5 and save it under the key pp1_broker_pa_id
    And through the query payment_status_pay retrieve param pp1_station_id at position 6 and save it under the key pp1_station_id
    And through the query payment_status_pay retrieve param pp1_payment_token at position 4 and save it under the key pp1_payment_token
    And through the query payment_status_pay retrieve param pp1_notice_id at position 2 and save it under the key pp1_notice_id
    And through the query payment_status_pay retrieve param pp1_pa_fiscal_code at position 1 and save it under the key pp1_pa_fiscal_code
    And through the query payment_status_pay retrieve param pp1_outcome at position 14 and save it under the key pp1_outcome
    And through the query payment_status_pay retrieve param pp1_creditor_reference_id at position 3 and save it under the key pp1_creditor_reference_id
    And through the query payment_status_pay retrieve param pp1_amount at position 12 and save it under the key pp1_amount
    And through the query payment_status_pay retrieve param pp1_psp_id at position 8 and save it under the key pp1_psp_id
    And through the query payment_status_pay retrieve param pp1_channel_id at position 10 and save it under the key pp1_channel_id
    #POSITION_SERVICE query
    And execution query position_service to get value on the table POSITION_SERVICE, with the columns DESCRIPTION, COMPANY_NAME under macro NewMod3 with db name nodo_online
    And through the query position_service retrieve param ps_description at position 0 and save it under the key ps_description
    And through the query position_service retrieve param ps_company_name at position 1 and save it under the key ps_company_name
    #POSITION_SUBJECT / POSITION_SERVICE query
    And execution query position_subject_service to get value on the table POSITION_SUBJECT, with the columns su.ENTITY_UNIQUE_IDENTIFIER_TYPE, su.ENTITY_UNIQUE_IDENTIFIER_VALUE, su.FULL_NAME, su.STREET_NAME, su.CIVIC_NUMBER, su.POSTAL_CODE, su.CITY, su.STATE_PROVINCE_REGION, su.COUNTRY, su.EMAIL under macro NewMod3 with db name nodo_online
    And through the query position_subject_service retrieve param pss_entity_unique_identifier_type at position 0 and save it under the key pss_entity_unique_identifier_type
    And through the query position_subject_service retrieve param pss_entity_unique_identifier_value at position 1 and save it under the key pss_entity_unique_identifier_value
    And through the query position_subject_service retrieve param pss_full_name at position 2 and save it under the key pss_full_name
    And through the query position_subject_service retrieve param pss_street_name at position 3 and save it under the key pss_street_name
    And through the query position_subject_service retrieve param pss_civic_number at position 4 and save it under the key pss_civic_number
    And through the query position_subject_service retrieve param pss_postal_code at position 5 and save it under the key pss_postal_code
    And through the query position_subject_service retrieve param pss_city at position 6 and save it under the key pss_city
    And through the query position_subject_service retrieve param pss_state_province_region at position 7 and save it under the key pss_state_province_region
    And through the query position_subject_service retrieve param pss_country at position 8 and save it under the key pss_country
    And through the query position_subject_service retrieve param pss_email at position 9 and save it under the key pss_email
    
    #POSITION_TRANSFER query
    And execution query position_transfer to get value on the table POSITION_TRANSFER, with the columns TRANSFER_IDENTIFIER, AMOUNT, PA_FISCAL_CODE_SECONDARY, IBAN, REMITTANCE_INFORMATION, TRANSFER_CATEGORY under macro NewMod3 with db name nodo_online
    And through the query position_transfer retrieve param pt_transfer_identifier at position 0 and save it under the key pt_transfer_identifier
    And through the query position_transfer retrieve param pt_amount at position 1 and save it under the key pt_amount
    And through the query position_transfer retrieve param pt_pa_fiscal_code_secondary at position 2 and save it under the key pt_pa_fiscal_code_secondary
    And through the query position_transfer retrieve param pt_iban at position 3 and save it under the key pt_iban
    And through the query position_transfer retrieve param pt_remittance_information at position 4 and save it under the key pt_remittance_information
    And through the query position_transfer retrieve param pt_transfer_category at position 5 and save it under the key pt_transfer_category
    
    #checks on XML
    And check value $prx_xml.idPA is equal to value $pp1_pa_fiscal_code
    And check value $prx_xml.idBrokerPA is equal to value $pp1_broker_pa_id
    And check value $prx_xml.idStation is equal to value $pp1_station_id
    And check value $prx_xml.receiptId is equal to value $pp1_payment_token
    And check value $prx_xml.noticeNumber is equal to value $pp1_notice_id
    And check value $prx_xml.fiscalCode is equal to value $pp1_pa_fiscal_code
    And check value $prx_xml.outcome is equal to value $pp1_outcome
    And check value $prx_xml.creditorReferenceId is equal to value $pp1_creditor_reference_id
    #And check value $prx_xml.paymentAmount is equal to value $pp1_amount
    And check value $prx_xml.description is equal to value $ps_description
    And check value $prx_xml.companyName is equal to value $ps_company_name
    And check value $prx_xml.entityUniqueIdentifierType is equal to value $pss_entity_unique_identifier_type
    And check value $prx_xml.entityUniqueIdentifierValue is equal to value $pss_entity_unique_identifier_value
    And check value $prx_xml.fullName is equal to value $pss_full_name
    And check value $prx_xml.streetName is equal to value $pss_street_name
    And check value $prx_xml.civicNumber is equal to value $pss_civic_number
    And check value $prx_xml.postalCode is equal to value $pss_postal_code
    And check value $prx_xml.city is equal to value $pss_city
    And check value $prx_xml.stateProvinceRegion is equal to value $pss_state_province_region
    And check value $prx_xml.country is equal to value $pss_country
    #And check value $prx_xml.e-mail is equal to value $pss_email
    And check value $prx_xml.idTransfer is equal to value $pt_transfer_identifier
    #And check value $prx_xml.transferAmount is equal to value $pt_amount
    And check value $prx_xml.fiscalCodePA is equal to value $pt_pa_fiscal_code_secondary
    And check value $prx_xml.IBAN is equal to value $pt_iban
    And check value $prx_xml.remittanceInformation is equal to value $pt_remittance_information
    And check value $prx_xml.transferCategory is equal to value $pt_transfer_category
    And check value $prx_xml.idPSP is equal to value $pp1_psp_id
    And check value $prx_xml.idChannel is equal to value $pp1_channel_id


    #POSITION_RECEIPT_XML 1 query
    And replace recipientStationId content with 90000000001_06 content
    And execution query get_receipt to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
    And through the query get_receipt retrieve xml prx_1xml at position 0 and save it under the key prx_1xml
    #checks on XML
    And check value $prx_1xml.idPA is equal to value 90000000001
    And check value $prx_1xml.idBrokerPA is equal to value 90000000001
    And check value $prx_1xml.idStation is equal to value 90000000001_06
    And check value $prx_1xml.receiptId is equal to value $pp1_payment_token
    And check value $prx_1xml.noticeNumber is equal to value $pp1_notice_id
    And check value $prx_1xml.fiscalCode is equal to value $pp1_pa_fiscal_code
    And check value $prx_1xml.outcome is equal to value $pp1_outcome
    And check value $prx_1xml.creditorReferenceId is equal to value $pp1_creditor_reference_id
    #And check value $prx_1xml.paymentAmount is equal to value $pp1_amount
    And check value $prx_1xml.description is equal to value $ps_description
    And check value $prx_1xml.companyName is equal to value $ps_company_name
    And check value $prx_1xml.entityUniqueIdentifierType is equal to value $pss_entity_unique_identifier_type
    And check value $prx_1xml.entityUniqueIdentifierValue is equal to value $pss_entity_unique_identifier_value
    And check value $prx_1xml.fullName is equal to value $pss_full_name
    And check value $prx_1xml.streetName is equal to value $pss_street_name
    And check value $prx_1xml.civicNumber is equal to value $pss_civic_number
    And check value $prx_1xml.postalCode is equal to value $pss_postal_code
    And check value $prx_1xml.city is equal to value $pss_city
    And check value $prx_1xml.stateProvinceRegion is equal to value $pss_state_province_region
    And check value $prx_1xml.country is equal to value $pss_country
    #And check value $prx_1xml.e-mail is equal to value $pss_email
    And check value $prx_1xml.idTransfer is equal to value $pt_transfer_identifier
    #And check value $prx_1xml.transferAmount is equal to value $pt_amount
    And check value $prx_1xml.fiscalCodePA is equal to value $pt_pa_fiscal_code_secondary
    And check value $prx_1xml.IBAN is equal to value $pt_iban
    And check value $prx_1xml.remittanceInformation is equal to value $pt_remittance_information
    And check value $prx_1xml.transferCategory is equal to value $pt_transfer_category
    And check value $prx_1xml.idPSP is equal to value $pp1_psp_id
    And check value $prx_1xml.idChannel is equal to value $pp1_channel_id


    #POSITION_RECEIPT_XML 2 query
    And replace recipientStationId content with 90000000001_09 content
    And execution query get_receipt to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
    And through the query get_receipt retrieve xml prx_2xml at position 0 and save it under the key prx_2xml
    #checks on XML
    And check value $prx_2xml.idPA is equal to value 90000000001
    And check value $prx_2xml.idBrokerPA is equal to value 90000000001
    And check value $prx_2xml.idStation is equal to value 90000000001_09
    And check value $prx_2xml.receiptId is equal to value $pp1_payment_token
    And check value $prx_2xml.noticeNumber is equal to value $pp1_notice_id
    And check value $prx_2xml.fiscalCode is equal to value $pp1_pa_fiscal_code
    And check value $prx_2xml.outcome is equal to value $pp1_outcome
    And check value $prx_2xml.creditorReferenceId is equal to value $pp1_creditor_reference_id
    #And check value $prx_2xml.paymentAmount is equal to value $pp1_amount
    And check value $prx_2xml.description is equal to value $ps_description
    And check value $prx_2xml.companyName is equal to value $ps_company_name
    And check value $prx_2xml.entityUniqueIdentifierType is equal to value $pss_entity_unique_identifier_type
    And check value $prx_2xml.entityUniqueIdentifierValue is equal to value $pss_entity_unique_identifier_value
    And check value $prx_2xml.fullName is equal to value $pss_full_name
    And check value $prx_2xml.streetName is equal to value $pss_street_name
    And check value $prx_2xml.civicNumber is equal to value $pss_civic_number
    And check value $prx_2xml.postalCode is equal to value $pss_postal_code
    And check value $prx_2xml.city is equal to value $pss_city
    And check value $prx_2xml.stateProvinceRegion is equal to value $pss_state_province_region
    And check value $prx_2xml.country is equal to value $pss_country
    #And check value $prx_2xml.e-mail is equal to value $pss_email
    And check value $prx_2xml.idTransfer is equal to value $pt_transfer_identifier
    #And check value $prx_2xml.transferAmount is equal to value $pt_amount
    And check value $prx_2xml.fiscalCodePA is equal to value $pt_pa_fiscal_code_secondary
    And check value $prx_2xml.IBAN is equal to value $pt_iban
    And check value $prx_2xml.remittanceInformation is equal to value $pt_remittance_information
    And check value $prx_2xml.transferCategory is equal to value $pt_transfer_category
    And check value $prx_2xml.idPSP is equal to value $pp1_psp_id
    And check value $prx_2xml.idChannel is equal to value $pp1_channel_id
