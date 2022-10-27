Feature: flux tests for demandPaymentNotice

    Background:
        Given systems up

    @skip
    Scenario: demandPaymentNotice
        Given initial XML demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idSoggettoServizio>00041</idSoggettoServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgo8dGE6dmVpY29sb0NvblRhcmdhPgo8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPgo8dGE6dmVpY29sb1RhcmdhPkFCMzQ1Q0Q8L3RhOnZlaWNvbG9UYXJnYT4KPC90YTp2ZWljb2xvQ29uVGFyZ2E+CjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paDemandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
            <outcome>OK</outcome>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <paymentList>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            </paf:paDemandPaymentNoticeResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends soap demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response

    @skip
    Scenario: activatePaymentNotice request
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
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
            <creditorReferenceId>11$iuv</creditorReferenceId>
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
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
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

    @skip
    Scenario: activatePaymentNotice request with 3 transfers
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
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
            <creditorReferenceId>11$iuv</creditorReferenceId>
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
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
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

    @skip
    Scenario: sendPaymentOutcome request
        Given initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
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
            <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
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

    # F_DPNR_01

    Scenario: F_DPNR_01 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: F_DPNR_01 (part 2)
        Given the F_DPNR_01 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT
        And checks the value $sendPaymentOutcome.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idChannel of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_01.1

    Scenario: F_DPNR_01.1 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: F_DPNR_01.1 (part 2)
        Given the F_DPNR_01.1 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And paymentChannel with None in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT
        And checks the value $sendPaymentOutcome.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idChannel of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NA of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_02

    Scenario: F_DPNR_02 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: F_DPNR_02 (part 2)
        Given the F_DPNR_02 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_03

    Scenario: F_DPNR_03 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        And expirationTime with 2000 in activatePaymentNotice
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: F_DPNR_03 (part 2)
        Given the F_DPNR_03 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1













    # F_DPNR_04

    Scenario: F_DPNR_04 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @wip
    Scenario: F_DPNR_04 (part 2)
        Given the F_DPNR_04 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT_TRANSFER
        And verify 3 record for the table POSITION_RECEIPT_TRANSFER JOIN POSITION_TRANSFER ON POSITION_TRANSFER.ID=POSITION_RECEIPT_TRANSFER.FK_POSITION_TRANSFER retrived by the query select_activate on db nodo_online under macro NewMod1























        # F_DPNR_05

    Scenario: F_DPNR_05 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @wip
    Scenario: F_DPNR_05 (part 2)
        Given the F_DPNR_05 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT_TRANSFER
        And verify 0 record for the table POSITION_RECEIPT_TRANSFER JOIN POSITION_TRANSFER ON POSITION_TRANSFER.ID=POSITION_RECEIPT_TRANSFER.FK_POSITION_TRANSFER retrived by the query select_activate on db nodo_online under macro NewMod1