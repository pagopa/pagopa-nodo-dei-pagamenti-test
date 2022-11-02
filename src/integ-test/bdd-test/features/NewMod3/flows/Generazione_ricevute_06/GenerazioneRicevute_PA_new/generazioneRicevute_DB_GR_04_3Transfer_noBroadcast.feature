# Il test verifica che in caso di 3Transfer e nessuna stazione broadcast nella paGetPaymentResponse sia generata una receipt +

Feature: 3Transfers - 1 receipt 

    Background:
        Given systems up
        And EC new version

    # verifyPaymentNotice phase
    Scenario: Execute verifyPaymentNotice request
        Given initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_old#</idChannel>
            <password>#password#</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        And initial xml paVerifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paVerifyPaymentNoticeRes>
            <outcome>OK</outcome>
            <paymentList>
            <paymentOptionDescription>
            <amount>1.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-10-28</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <!--Optional:-->
            <paymentDescription>/RFB/311$iuv/5.00/TXT/</paymentDescription>
            <!--Optional:-->
            <fiscalCodePA>77777777777</fiscalCodePA>
            <!--Optional:-->
            <companyName>company PA</companyName>
            <!--Optional:-->
            <officeName>office PA</officeName>
            </paf:paVerifyPaymentNoticeRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    # activate phase
    Scenario: Execute activatePaymentNotice request
        Given the Execute verifyPaymentNotice request scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header />
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_old#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311$iuv</noticeNumber>
            </qrCode>
            <expirationTime>2000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial xml paGetPayment
            """
            <soapenv:Envelope
            xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>11$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-31</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>99</civicNumber>
            <!--Optional:-->
            <postalCode>20155</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>prova@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>44444444444</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>test</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>test</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>90000000002</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>test</transferCategory>
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
        And save activatePaymentNotice response in activatePaymentNoticeResponse

    # Payment Outcome Phase outcome OK - paymentChannel Presente
    Scenario: Execute sendPaymentOutcome request
        Given the Execute activatePaymentNotice request scenario executed successfully
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_old#</idChannel>
            <password>#password#</password>
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

    # DB check
    Scenario: DB check
        Given the Execute sendPaymentOutcome request scenario executed successfully
        And wait 15 seconds for expiration
        # POSITION_RECEIPT
        Then verify 1 record for the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value OK of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value 10 of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value #canale_old# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value None of the record at column FEE_PA of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value None of the record at column BUNDLE_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value None of the record at column BUNDLE_PA_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        # POSITION_RECEIPT_RECIPIENT
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value 66666666666_01 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt on db nodo_online under macro NewMod3
        # RE
        And verify 2 record for the table RE retrived by the query select_paSendRT on db re under macro sendPaymentResultV2
        And checks the value REQ,RESP of the record at column SOTTO_TIPO_EVENTO of the table RE retrived by the query select_paSendRT on db re under macro sendPaymentResultV2
        And checks the value 66666666666_01,66666666666_01 of the record at column IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA of the table RE retrived by the query select_paSendRT on db re under macro sendPaymentResultV2











