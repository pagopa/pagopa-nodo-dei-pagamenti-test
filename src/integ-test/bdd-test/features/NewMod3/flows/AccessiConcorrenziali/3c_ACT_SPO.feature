Feature: process tests for accessiConCorrenziali [3c_ACT_SPO]

    Background:
        Given systems up
        And EC new version

    # 3c_ACT_SPO
    Scenario: Execute activatePaymentNotice request
        Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber  
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
        <expirationTime>2000</expirationTime>
        <amount>10.00</amount>
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
        And save activatePaymentNotice response in activatePaymentNotice1

    Scenario: trigger poller annulli
        Given the Execute activatePaymentNotice request scenario executed successfully
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200


    Scenario: Execute second activatePaymentNotice request
        Given the trigger poller annulli scenario executed successfully
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
        <amount>8.00</amount>
        </nod:activatePaymentNoticeReq>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        Then saving activatePaymentNotice request in activatePaymentNotice2

    Scenario: Excecute sendPaymentOutcome request
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
            <paymentToken>$activatePaymentNotice1Response.paymentToken</paymentToken>
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
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
        Then saving sendPaymentOutcome request in sendPaymentOutcome1

    @check
    Scenario: parallel calls and test scenario
        Given the Excecute sendPaymentOutcome request scenario executed successfully
        And calling primitive activatePaymentNotice_activatePaymentNotice2 POST and sendPaymentOutcome_sendPaymentOutcome1 POST in parallel
        Then check primitive response activatePaymentNotice2Response and primitive response sendPaymentOutcome1Response