Feature: process tests for Retry_DB_GR_08

  Background:
      Given systems up
      And initial XML verifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
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

# Define primitive paGetPayment
  Scenario: Define paGetPayment
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
                <transferAmount>10.00</transferAmount>
                <fiscalCodePA>77777777777</fiscalCodePA>
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

  Scenario: Initial activatePaymentNotice request
      Given the Define paGetPayment scenario executed successfully
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




  # Activate phase
  Scenario: Execute activatePaymentNotice request
      Given the Initial activatePaymentNotice request scenario executed successfully
      And the Define paGetPayment scenario executed successfully
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      And job mod3CancelV2 triggered after 3 seconds
      Then check outcome is OK of activatePaymentNotice response
      And verify the HTTP status code of mod3CancelV2 response is 200



   # Payment Outcome Phase outcome OK
    Scenario: Execute sendPaymentOutcome request
      Given the Execute activatePaymentNotice request scenario executed successfully
      And EC replies to nodo-dei-pagamenti with the paGetPayment
      And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer></transferList> in paGetPayment
      And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
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
      And checks the value None of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
      And checks the value None of the record at column NOTICE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
      And checks the value None of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
      And checks the value None of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
      And checks the value None of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
      And checks the value None of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
      And checks the value None of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
      And checks the value None of the record at column STATUS of the table POSITION_RECEIPT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3
      And checks the value None of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3


      


