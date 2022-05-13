Feature: syntax checks for paGetPaymentRes - KO - SIN_PGPR_46

Background:
  Given systems up
  And initial XML activatePaymentNotice
  """
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
     <soapenv:Header />
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
           <amount>10.00</amount>
           <dueDate>2021-12-31</dueDate>
           <paymentNote>causale</paymentNote>
        </nod:activatePaymentNoticeReq>
     </soapenv:Body>
  </soapenv:Envelope>
  """
  And EC new version
  
  Scenario: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given initial XML paGetPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
       <soapenv:Header />
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

    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response