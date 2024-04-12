#Il test verifica che il nodo accetti un'activatePAymentNoticeV2 con marca da bollo digitale 278

Feature: activatePaymentNoticeV2Request with MBD flow OK

    Background:
        Given systems up
        

    # checkPosition phase
    Scenario: Execute checkPosition request
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "310#iuv#"
                    }
                ]
            }
            """
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    # activateV2 phase
    Scenario: activatePaymentNoticeV2
        Given the Execute checkPosition request scenario executed successfully
        And initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#pspEcommerce#</idPSP>
            <idBrokerPSP>#brokerEcommerce#</idBrokerPSP>
            <idChannel>#canaleEcommerce#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310$iuv</noticeNumber>
            </qrCode>
            <expirationTime>6000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <companyName>companySec</companyName>
            <richiestaMarcaDaBollo>
            <hashDocumento>ciao</hashDocumento>
            <tipoBollo>01</tipoBollo>
            <provinciaResidenza>MI</provinciaResidenza>
            </richiestaMarcaDaBollo>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </metadata>
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
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check idTransfer is 1 of activatePaymentNoticeV2 response
        And check hashDocumento is ciao of activatePaymentNoticeV2 response
        And check tipoBollo is 01 of activatePaymentNoticeV2 response
        And check provinciaResidenza is MI of activatePaymentNoticeV2 response

    @test 
    #DB check
    Scenario: DB check
        Given the activatePaymentNoticeV2 scenario executed successfully
        And wait 5 seconds for expiration
        # POSITION_TRANSFER
        Then verify 1 record for the table POSITION_TRANSFER retrived by the query position_transfer_nmu_asc on db nodo_online under macro sendPaymentResultV2
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_TRANSFER retrived by the query position_transfer_nmu_asc on db nodo_online under macro sendPaymentResultV2
        And checks the value None of the record at column IBAN of the table POSITION_TRANSFER retrived by the query position_transfer_nmu_asc on db nodo_online under macro sendPaymentResultV2
        And checks the value 10 of the record at column AMOUNT of the table POSITION_TRANSFER retrived by the query position_transfer_nmu_asc on db nodo_online under macro sendPaymentResultV2
        And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column REMITTANCE_INFORMATION  of the table POSITION_TRANSFER retrived by the query position_transfer_nmu_asc on db nodo_online under macro sendPaymentResultV2
        And checks the value 01 of the record at column REQ_TIPO_BOLLO of the table POSITION_TRANSFER retrived by the query position_transfer_nmu_asc on db nodo_online under macro sendPaymentResultV2
        And checks the value ciao of the record at column REQ_HASH_DOCUMENTO of the table POSITION_TRANSFER retrived by the query position_transfer_nmu_asc on db nodo_online under macro sendPaymentResultV2
        And checks the value MI of the record at column REQ_PROVINCIA_RESIDENZA of the table POSITION_TRANSFER retrived by the query position_transfer_nmu_asc on db nodo_online under macro sendPaymentResultV2
        # POSITION_TRANSFER_MBD
        And verify 0 record for the table POSITION_TRANSFER_MBD retrived by the query position_transfer_mbd on db nodo_online under macro sendPaymentResultV2
        # POSITION_PAYMENT
        And checks the value Y of the record at column MBD of the table POSITION_PAYMENT retrived by the query position_transfer_nmu_asc on db nodo_online under macro sendPaymentResultV2