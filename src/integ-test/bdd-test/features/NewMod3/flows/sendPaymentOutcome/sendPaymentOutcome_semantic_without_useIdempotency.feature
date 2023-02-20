Feature: semantic check for sendPaymentOutcomeReq regarding idempotency - not use idempotency [IDMP_SPO_22]

  Background:
    Given systems up

  Scenario: Execute activatePaymentNotice request
    Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
    And initial XML activatePaymentNotice
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
                <noticeNumber>$1noticeNumber</noticeNumber>
             </qrCode>
             <expirationTime>120000</expirationTime>
             <amount>10.00</amount>
             <dueDate>2021-12-31</dueDate>
             <paymentNote>causale</paymentNote>
          </nod:activatePaymentNoticeReq>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    And initial XML paGetPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
        <soapenv:Header />
        <soapenv:Body>
            <paf:paGetPaymentRes>
                <outcome>OK</outcome>
                <data>
                    <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
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
    And nodo-dei-pagamenti has config parameter useIdempotency set to false
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send payment outcome Phase 1
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
                <idempotencyKey>#idempotency_key#</idempotencyKey>
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

@@ciao 
  # Send payment outcome Phase 2 
  Scenario: Execute again sendPaymentOutcome request before idempotencyKey expires
    Given the Execute sendPaymentOutcome request scenario executed successfully
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
    And restore initial configurations