Feature: process tests for generazioneRicevute 

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

  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
                  <expirationTime>120000</expirationTime>
                  <amount>10.00</amount>
                  <dueDate>2021-12-31</dueDate>
                  <paymentNote>causale</paymentNote>
              </nod:activatePaymentNoticeReq>
          </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


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

   Scenario: Execution test DB_GR_03/09
    Given the Execute activatePaymentNotice request scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer></transferList> in paGetPayment
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    And EC replies to nodo-dei-pagamenti with the paGetPaymentRes
    #To Do implementare tutti gli altri test in funzione delle decisioni di pagopa
    Then api-config executes the sql {sql_code} and check POSITION_RECEIPT
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT_TRANSFER 
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT_RECIPIENT_STATUS
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT_XML
    # non è popolata 

   Scenario: Execution test DB_GR_06/12
    Given the Execute activatePaymentNotice request scenario executed successfully
    # And broadcast == false da settare con api config 
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>44444444444</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation></transfer><transfer><idTransfer>3</idTransfer><transferAmount>4.00</transferAmount><fiscalCodePA>90000000002</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation></transfer> in paGetPayment
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    And EC replies to nodo-dei-pagamenti with the paGetPaymentRes
    #To Do implementare tutti gli altri test in funzione delle decisioni di pagopa
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT_TRANSFER 
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT_RECIPIENT_STATUS
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT_XML
    # non è popolata 
















