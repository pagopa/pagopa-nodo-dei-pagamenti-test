Feature: process tests for generazioneRicevute

    Background:
        Given systems up

    # Verify phase
    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with Y, with where condition FK_PA and where value ('6','8') under macro update_query on db nodo_cfg
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
            <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: Execute activatePaymentNotice (Phase 2)
        Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activatePaymentNoticeReq>
                    <idPSP>$verifyPaymentNotice.idPSP</idPSP>
                    <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
                    <idChannel>$verifyPaymentNotice.idChannel</idChannel>
                    <password>pwdpwdpwd</password>
                    <idempotencyKey>#idempotency_key#</idempotencyKey>
                    <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
                    </qrCode>
                    <expirationTime>2000</expirationTime>
                    <amount>10.00</amount>
                    <paymentNote>responseFull3Transfers</paymentNote>
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
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

@runnable @dependentwrite @lazy @dependentwrite
  Scenario: Execute sendPaymentOutcome (Phase 1)
    Given the Execute activatePaymentNotice (Phase 2) scenario executed successfully
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
                <outcome>KO</outcome>
                <details>
                    <paymentMethod>creditCard</paymentMethod>
                    <paymentChannel>app</paymentChannel>
                    <fee>2.00</fee>
                    <payer>
                    <uniqueIdentifier>
                        <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                        <entityUniqueIdentifierValue>#id_station_old#</entityUniqueIdentifierValue>
                    </uniqueIdentifier>
                    <fullName>name</fullName>
                    <streetName>street</streetName>
                    <civicNumber>civic</civicNumber>
                    <postalCode>postal</postalCode>
                    <city>city</city>
                    <stateProvinceRegion>state</stateProvinceRegion>
                    <country>IT</country>
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
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        And update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition FK_PA and where value ('6','8') under macro update_query on db nodo_cfg

        # DB Check
        And verify 0 record for the table POSITION_RECEIPT_TRANSFER retrived by the query position_receipt_transfer on db nodo_online under macro NewMod3

        # DB check - POSITION_RECEIPT_RECIPIENT_PA_INTESTATARIA
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
        And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query pos_receipt_recipient_status_order_by on db nodo_online under macro NewMod3