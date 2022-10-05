Feature: process tests for paSendRT

  Background:
    Given systems up

    Scenario: Execute verifyPaymentNotice request
        Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr_old# and application code NA
        And generate 1 cart with PA #creditor_institution_code_old# and notice number $1noticeNumber  
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
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
                <soapenv:Header />
                <soapenv:Body>
                    <paf:paGetPaymentRes>
                        <outcome>OK</outcome>
                        <data>
                            <creditorReferenceId>$1iuv</creditorReferenceId>
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
                                    <transferAmount>3.00</transferAmount>
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
            <expirationTime>6000</expirationTime>
            <amount>10.00</amount>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response


    Scenario: Define sendPaymentOutcome
        Given initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                <paf:paSendRTRes>
                    <outcome>OK</outcome>
                    <delay>10000</delay>
                </paf:paSendRTRes>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paSendRT
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:sendPaymentOutcomeReq>
                <idPSP>#psp#</idPSP>
                <idBrokerPSP>#psp#</idBrokerPSP>
                <idChannel>#canale#</idChannel>
                <password>pwdpwdpwd</password>
                <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
                <outcome>OK</outcome>
                <!--Optional:-->
                <details>
                    <paymentMethod>creditCard</paymentMethod>
                    <!--Optional:-->
                    <paymentChannel>app</paymentChannel>
                    <fee>2.00</fee>
                    <!--Optional:-->
                    <payer>
                    <uniqueIdentifier>
                        <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                        <entityUniqueIdentifierValue>#id_station#</entityUniqueIdentifierValue>
                    </uniqueIdentifier>
                    <fullName>name</fullName>
                    <!--Optional:-->
                    <streetName>street</streetName>
                    <!--Optional:-->
                    <civicNumber>civic</civicNumber>
                    <!--Optional:-->
                    <postalCode>postal</postalCode>
                    <!--Optional:-->
                    <city>city</city>
                    <!--Optional:-->
                    <stateProvinceRegion>state</stateProvinceRegion>
                    <!--Optional:-->
                    <country>IT</country>
                    <!--Optional:-->
                    <e-mail>prova@test.it</e-mail>
                    </payer>
                    <applicationDate>2021-12-12</applicationDate>
                    <transferDate>2021-12-11</transferDate>
                </details>
                </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And job paSendRt triggered after 6 seconds
        And wait 15 seconds for expiration
        Then check outcome is OK of sendPaymentOutcome response