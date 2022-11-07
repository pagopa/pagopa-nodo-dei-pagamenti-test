Feature: process tests for generazioneRicevute [DB_GR_15]

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
    # get broadcast value
    And execution query get_broadcast to get value on the table PA_STAZIONE_PA, with the columns psp.OBJ_ID, psp.BROADCAST under macro costanti with db name nodo_cfg
    And through the query get_broadcast retrieve param broadcast_id at position 0 and save it under the key broadcast_id
    And through the query get_broadcast retrieve param broadcast_value at position 1 and save it under the key broadcast_value
    # set broadcast=true
    And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'Y', with where condition OBJ_ID = '$broadcast_id' under macro update_query on db nodo_cfg
    When refresh job PA triggered after 10 seconds
    And wait 15 seconds for expiration
    And PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
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
      <expirationTime>4000</expirationTime>
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

@runnable
  # Trigger Poller Annulli
  Scenario: Trigger Poller Annulli
    Given the Execute activatePaymentNotice request scenario executed successfully
    When job mod3CancelV2 triggered after 10 seconds
    Then wait 15 seconds for expiration

    # set broadcast=false
    And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'N', with where condition OBJ_ID = '$broadcast_id' under macro update_query on db nodo_cfg
    And refresh job PA triggered after 10 seconds

    # db checks
    And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
    And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
    And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
