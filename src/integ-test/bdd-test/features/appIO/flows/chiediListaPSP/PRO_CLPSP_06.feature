Feature: PRO_CLPSP_06 53

Background:
 Given systems up
 

 Scenario: Execute verifyPaymentNotice (Phase 1)
    Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 6000
    And initial XML verifyPaymentNotice
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
        <nod:verifyPaymentNoticeReq>
            <idPSP>#psp_AGID#</idPSP>
            <idBrokerPSP>#broker_AGID#</idBrokerPSP>
            <idChannel>#canale_AGID#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
                <fiscalCode>#creditor_institution_code#</fiscalCode>
                <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
        </nod:verifyPaymentNoticeReq>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    When AppIO sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

Scenario: Execute activateIOPayment (Phase 2)
    Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
    And initial XML activateIOPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <nod:activateIOPaymentReq>
                <idPSP>$verifyPaymentNotice.idPSP</idPSP>
                <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
                <idChannel>$verifyPaymentNotice.idChannel</idChannel>
                <password>pwdpwdpwd</password>
                <!--Optional:-->
                <idempotencyKey>#idempotency_key#</idempotencyKey>
                <qrCode>
                    <fiscalCode>#creditor_institution_code#</fiscalCode>
                    <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
                </qrCode>
                <!--Optional:-->
                <expirationTime>6000</expirationTime>
                <amount>10.00</amount>
                <!--Optional:-->
                <dueDate>2021-12-12</dueDate>
                <!--Optional:-->
                <paymentNote>test</paymentNote>
                <!--Optional:-->
                <payer>
                    <uniqueIdentifier>
                        <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                        <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
                    </uniqueIdentifier>
                    <fullName>name</fullName>
                    <!--Optional:-->
                    <streetName>street</streetName>
                    <!--Optional:-->
                    <civicNumber>civic</civicNumber>
                    <!--Optional:-->
                    <postalCode>code</postalCode>
                    <!--Optional:-->
                    <city>city</city>
                    <!--Optional:-->
                    <stateProvinceRegion>state</stateProvinceRegion>
                    <!--Optional:-->
                    <country>IT</country>
                    <!--Optional:-->
                    <e-mail>test.prova@gmail.com</e-mail>
                </payer>
            </nod:activateIOPaymentReq>
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
                     <creditorReferenceId>$iuv</creditorReferenceId>
                     <paymentAmount>10.00</paymentAmount>
                     <dueDate>2021-12-31</dueDate>
                     <!--Optional:-->
                     <retentionDate>2021-12-31T12:12:12</retentionDate>
                     <!--Optional:-->
                     <lastPayment>0</lastPayment>
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
                           <transferAmount>3.00</transferAmount>
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
                           <remittanceInformation>testPaGetPayment</remittanceInformation>
                           <transferCategory>paGetPaymentTest</transferCategory>
                        </transfer>
                        <transfer>
                           <idTransfer>3</idTransfer>
                           <transferAmount>4.00</transferAmount>
                           <fiscalCodePA>90000000002</fiscalCodePA>
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
    When AppIO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
    Given the Execute activateIOPayment (Phase 2) scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

Scenario: trigger PollerAnnulli
   Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
   When job mod3CancelV2 triggered after 10 seconds
   Then wait 10 seconds for expiration

@sync
Scenario: Execute activateIOPayment1 (Phase 4)
    Given the trigger PollerAnnulli scenario executed successfully
    And initial XML activateIOPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <nod:activateIOPaymentReq>
                <idPSP>$verifyPaymentNotice.idPSP</idPSP>
                <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
                <idChannel>$verifyPaymentNotice.idChannel</idChannel>
                <password>pwdpwdpwd</password>
                <!--Optional:-->
                <idempotencyKey>#idempotency_key#</idempotencyKey>
                <qrCode>
                    <fiscalCode>#creditor_institution_code#</fiscalCode>
                    <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
                </qrCode>
                <!--Optional:-->
                <expirationTime>60000</expirationTime>
                <amount>10.00</amount>
                <!--Optional:-->
                <dueDate>2021-12-12</dueDate>
                <!--Optional:-->
                <paymentNote>test</paymentNote>
                <!--Optional:-->
                <payer>
                    <uniqueIdentifier>
                        <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                        <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
                    </uniqueIdentifier>
                    <fullName>name</fullName>
                    <!--Optional:-->
                    <streetName>street</streetName>
                    <!--Optional:-->
                    <civicNumber>civic</civicNumber>
                    <!--Optional:-->
                    <postalCode>code</postalCode>
                    <!--Optional:-->
                    <city>city</city>
                    <!--Optional:-->
                    <stateProvinceRegion>state</stateProvinceRegion>
                    <!--Optional:-->
                    <country>IT</country>
                    <!--Optional:-->
                    <e-mail>test.prova@gmail.com</e-mail>
                </payer>
            </nod:activateIOPaymentReq>
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
                     <creditorReferenceId>$iuv</creditorReferenceId>
                     <paymentAmount>10.00</paymentAmount>
                     <dueDate>2021-12-31</dueDate>
                     <!--Optional:-->
                     <retentionDate>2021-12-31T12:12:12</retentionDate>
                     <!--Optional:-->
                     <lastPayment>0</lastPayment>
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
                           <transferAmount>3.00</transferAmount>
                           <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                           <IBAN>IT45R0760103200000000001016</IBAN>
                           <remittanceInformation>testPaGetPayment</remittanceInformation>
                           <transferCategory>paGetPaymentTest</transferCategory>
                        </transfer>
                        <transfer>
                           <idTransfer>2</idTransfer>
                           <transferAmount>3.00</transferAmount>
                           <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                           <IBAN>IT45R0760103200000000001016</IBAN>
                           <remittanceInformation>testPaGetPayment</remittanceInformation>
                           <transferCategory>paGetPaymentTest</transferCategory>
                        </transfer>
                        <transfer>
                           <idTransfer>3</idTransfer>
                           <transferAmount>4.00</transferAmount>
                           <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                           <IBAN>IT96R0123451234512345678904</IBAN>
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
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
@sync
Scenario: Check PSP list
    Given the Execute activateIOPayment1 (Phase 4) scenario executed successfully
    When WISP sends rest GET listaPSP?idPagamento=$activateIOPaymentResponse.paymentToken&percorsoPagamento=CARTE to nodo-dei-pagamenti
    Then verify the HTTP status code of listaPSP response is 200
    # DB Check
    And execution query version to get value on the table ELENCO_SERVIZI_PSP_SYNC_STATUS, with the columns SNAPSHOT_VERSION under macro Mod1 with db name nodo_offline
    And through the query version retrieve param version at position 0 and save it under the key version
    And replace importoTot content with 10.00 content
    And execution query getPspCarte to get value on the table ELENCO_SERVIZI_PSP, with the columns ID under macro AppIO with db name nodo_offline
    And through the query getPspCarte retrieve param listaCarte at position -1 and save it under the key listaCarte
    And check data is $listaCarte of listaPSP response
    And restore initial configurations