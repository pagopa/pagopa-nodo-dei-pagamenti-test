Feature: activateV2 Ecommerce - noticeID != creditorReferenceId

    Background:
        Given systems up

    @runnable
    Scenario: activatePaymentNoticeV2 request
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        # And initial XML paGetPaymentV2
        #     """
        #     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
        #     <soapenv:Header/>
        #     <soapenv:Body>
        #     <paf:paGetPaymentV2Response>
        #     <outcome>OK</outcome>
        #     <data>
        #     <creditorReferenceId></creditorReferenceId>
        #     <paymentAmount>10.00</paymentAmount>
        #     <dueDate>2021-12-12</dueDate>
        #     <!--Optional:-->
        #     <retentionDate>2021-12-30T12:12:12</retentionDate>
        #     <!--Optional:-->
        #     <lastPayment>1</lastPayment>
        #     <description>test</description>
        #     <companyName>company</companyName>
        #     <!--Optional:-->
        #     <officeName>office</officeName>
        #     <debtor>
        #     <uniqueIdentifier>
        #     <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
        #     <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
        #     </uniqueIdentifier>
        #     <fullName>paGetPaymentName</fullName>
        #     <!--Optional:-->
        #     <streetName>paGetPaymentStreet</streetName>
        #     <!--Optional:-->
        #     <civicNumber>paGetPayment99</civicNumber>
        #     <!--Optional:-->
        #     <postalCode>20155</postalCode>
        #     <!--Optional:-->
        #     <city>paGetPaymentCity</city>
        #     <!--Optional:-->
        #     <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
        #     <!--Optional:-->
        #     <country>IT</country>
        #     <!--Optional:-->
        #     <e-mail>paGetPayment@test.it</e-mail>
        #     </debtor>
        #     <transferList>
        #     <!--1 to 5 repetitions:-->
        #     <transfer>
        #     <idTransfer>1</idTransfer>
        #     <transferAmount>10.00</transferAmount>
        #     <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
        #     <companyName>companySec</companyName>
        #     <IBAN>IT45R0760103200000000001016</IBAN>
        #     <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
        #     <transferCategory>paGetPaymentTest</transferCategory>
        #     <!--Optional:-->
        #     <metadata>
        #     <!--1 to 10 repetitions:-->
        #     <mapEntry>
        #     <key>1</key>
        #     <value>22</value>
        #     </mapEntry>
        #     </metadata>
        #     </transfer>
        #     </transferList>
        #     <!--Optional:-->
        #     <metadata>
        #     <!--1 to 10 repetitions:-->
        #     <mapEntry>
        #     <key>1</key>
        #     <value>22</value>
        #     </mapEntry>
        #     </metadata>
        #     </data>
        #     </paf:paGetPaymentV2Response>
        #     </soapenv:Body>
        #     </soapenv:Envelope>
        #     """
        # And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check description is iuv not contained in notice number of activatePaymentNoticeV2 response


    @runnable
    Scenario: second activatePaymentNoticeV2 request
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#pspEcommerce#</idPSP>
            <idBrokerPSP>#brokerEcommerce#</idBrokerPSP>
            <idChannel>#canaleEcommerce#</idChannel>
            <password>#password#</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>309#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response