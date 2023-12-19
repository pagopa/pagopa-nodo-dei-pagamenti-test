Feature: process tests for paSendRT [PSRT_30]

    Background:
        Given systems up

    # PSRT_21

    Scenario: 21 Execute verifyPaymentNotice request
        Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
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
        And EC new version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: 21 Execute activatePaymentNotice request
        Given the 21 Execute verifyPaymentNotice request scenario executed successfully
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


    Scenario: 21 Define sendPaymentOutcome
        Given the 21 Execute activatePaymentNotice request scenario executed successfully
        And initial XML paSendRT
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
        #And job paSendRt triggered after 6 seconds
        And wait 10 seconds for expiration
        Then check outcome is OK of sendPaymentOutcome response

        # DB Check
        And execution query position_transfer to get value on the table POSITION_RECEIPT_RECIPIENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        And execution query position_status_n to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_GENERATED,NOTICE_SENT,PAYING,PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_status_n to get value on the table POSITION_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # db update config
        And nodo-dei-pagamenti has config parameter scheduler.paSendRtMaxRetry set to 1


    Scenario: 21 clean paSendRt queue
        Given the 21 Define sendPaymentOutcome scenario executed successfully
        When job paSendRt triggered after 5 seconds
        And wait 10 seconds for expiration

    @runnable
    Scenario: 21 job paSendRt
        Given the 21 Define sendPaymentOutcome scenario executed successfully
        And initial XML paSendRT
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
        When job paSendRt triggered after 6 seconds
        And wait 15 seconds for expiration
        Then checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3


    # PSRT_22

    Scenario: 22 Execute verifyPaymentNotice request
        Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition FK_PA and where value ('6','8') under macro update_query on db nodo_cfg
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
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
        And EC new version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: 22 Execute activatePaymentNotice request
        Given the 22 Execute verifyPaymentNotice request scenario executed successfully
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
            <paymentNote>responseFull3Transfers</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response


    Scenario: 22 Define sendPaymentOutcome
        Given the 22 Execute activatePaymentNotice request scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
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
        #And job paSendRt triggered after 6 seconds
        And wait 10 seconds for expiration
        Then check outcome is OK of sendPaymentOutcome response
        # DB Check
        And execution query position_transfer to get value on the table POSITION_RECEIPT_RECIPIENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        And execution query position_status_n to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_GENERATED,NOTICE_SENT,PAYING,PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # db update config
        And nodo-dei-pagamenti has config parameter scheduler.paSendRtMaxRetry set to 1


    Scenario: 22 clean paSendRt queue
        Given the 22 Define sendPaymentOutcome scenario executed successfully
        When job paSendRt triggered after 5 seconds
        And wait 10 seconds for expiration

    @runnable
    Scenario: 22 job paSendRt
        Given the 22 Define sendPaymentOutcome scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
            </paf:paSendRTRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paSendRT
        When job paSendRt triggered after 6 seconds
        And wait 15 seconds for expiration
        Then checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3


    # PSRT_23

    Scenario: 23 job refresh pa (1)
        Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with Y, with where condition OBJ_ID and where value ('13','1201') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds

    Scenario: 23 Execute verifyPaymentNotice request
        Given the 23 job refresh pa (1) scenario executed successfully
        And wait 5 seconds for expiration
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
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
        And EC new version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: 23 Execute activatePaymentNotice request
        Given the 23 Execute verifyPaymentNotice request scenario executed successfully
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header />
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
            <paymentAmount>17.00</paymentAmount>
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
            <entityUniqueIdentifierValue>77777777777777</entityUniqueIdentifierValue>
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
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>90000000002</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
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
            <idPSP>$verifyPaymentNotice.idPSP</idPSP>
            <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
            <idChannel>$verifyPaymentNotice.idChannel</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>17.00</amount>
            <paymentNote>responseFull3Transfers</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response


    Scenario: 23 Define sendPaymentOutcome
        Given the 23 Execute activatePaymentNotice request scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
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
        #And job paSendRt triggered after 6 seconds
        Then check outcome is OK of sendPaymentOutcome response

    #Scenario: 23 trigger jobs paSendRt
    #Given the Execute sendPaymentOutcome request scenario executed successfully
    #When job paSendRt triggered after 5 seconds
    #Then verify the HTTP status code of paSendRt response is 200

    @runnable
    Scenario: 23 DB check + db update
        Given the 23 Define sendPaymentOutcome scenario executed successfully
        And wait 10 seconds for expiration
        And update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition OBJ_ID and where value ('13','1201') under macro update_query on db nodo_cfg
        And execution query position_transfer to get value on the table POSITION_RECEIPT_RECIPIENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And verify 9 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        And execution query position_status_n to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_GENERATED,NOTICE_SENT,PAYING,PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        #And execution query position_status_n to get value on the table POSITION_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        #And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3#
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # Scenario: 23 job refresh pa (2)
        #     Given the 23 DB check + db update scenario executed successfully
        Then refresh job ALL triggered after 10 seconds




    # PSRT_24

    Scenario: 24 job refresh pa (1)
        Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with Y, with where condition OBJ_ID and where value ('13','1201') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds

    Scenario: 24 Execute verifyPaymentNotice request
        Given the 24 job refresh pa (1) scenario executed successfully
        And wait 5 seconds for expiration
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
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
        And EC new version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: 24 Execute activatePaymentNotice request
        Given the 24 Execute verifyPaymentNotice request scenario executed successfully
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header />
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
            <paymentAmount>13.00</paymentAmount>
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
            <entityUniqueIdentifierValue>77777777777777</entityUniqueIdentifierValue>
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
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
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
            <idPSP>$verifyPaymentNotice.idPSP</idPSP>
            <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
            <idChannel>$verifyPaymentNotice.idChannel</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>13.00</amount>
            <paymentNote>responseFull3Transfers</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response


    Scenario: 24 Define sendPaymentOutcome
        Given the 24 Execute activatePaymentNotice request scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
            </paf:paSendRTRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And nodo-dei-pagamenti has config parameter scheduler.jobName_paSendRt.enabled set to false
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
        #And job paSendRt triggered after 6 seconds
        Then check outcome is OK of sendPaymentOutcome response

    #Scenario: 24 trigger jobs paSendRt
    #Given the Execute sendPaymentOutcome request scenario executed successfully
    #When job paSendRt triggered after 5 seconds
    #Then verify the HTTP status code of paSendRt response is 200

    @runnable
    Scenario: 24 DB check + db update
        Given the 24 Define sendPaymentOutcome scenario executed successfully
        And wait 10 seconds for expiration
        And update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition OBJ_ID and where value ('13','1201') under macro update_query on db nodo_cfg
        And execution query position_transfer to get value on the table POSITION_RECEIPT_RECIPIENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And verify 6 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        And execution query position_status_n to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_GENERATED,NOTICE_SENT,PAYING,PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And execution query position_transfer to get value on the table POSITION_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        #And execution query position_status_n to get value on the table POSITION_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        #And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3#
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3

        # Scenario: 24 job refresh pa (2)
        #     Given the 24 DB check + db update scenario executed successfully
        Then refresh job ALL triggered after 10 seconds
        And restore initial configurations


    # PSRT_26
    Scenario: 26 Execute verifyPaymentNotice request
        Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with Y, with where condition OBJ_ID and where value ('1201') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        And wait 5 seconds for expiration
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
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
        And EC new version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: 26 Execute activatePaymentNotice request
        Given the 26 Execute verifyPaymentNotice request scenario executed successfully
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header />
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
            <paymentAmount>15.00</paymentAmount>
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
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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
            <amount>15.00</amount>
            <paymentNote>responseFull3Transfers</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: 26 Define sendPaymentOutcome
        Given the 26 Execute activatePaymentNotice request scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
            </paf:paSendRTRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And nodo-dei-pagamenti has config parameter scheduler.jobName_paSendRt.enabled set to false
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
        #And job paSendRt triggered after 6 seconds
        And wait 10 seconds for expiration
        Then check outcome is OK of sendPaymentOutcome response
        And update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition OBJ_ID and where value ('1201') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        And wait 10 seconds for expiration
        # DB Check
        #And execution query position_transfer to get value on the table POSITION_RECEIPT_RECIPIENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        #And execution query position_status_n to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTIFIED,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_status_n on db nodo_online under macro NewMod3
        #And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_GENERATED,NOTICE_SENT,PAYING,PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        #And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        #And execution query position_transfer to get value on the table POSITION_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        #And execution query position_status_n to get value on the table POSITION_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # db update config
        And nodo-dei-pagamenti has config parameter scheduler.paSendRtMaxRetry set to 1

    Scenario: 26 clean paSendRt queue
        Given the 26 Define sendPaymentOutcome scenario executed successfully
        When job paSendRt triggered after 5 seconds
        And wait 10 seconds for expiration

    
    Scenario: 26 job paSendRt
        Given the 26 Define sendPaymentOutcome scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
            </paf:paSendRTRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paSendRT
        And nodo-dei-pagamenti has config parameter scheduler.jobName_paSendRt.enabled set to true
        When job paSendRt triggered after 6 seconds
        And wait 15 seconds for expiration
        Then checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And restore initial configurations

    # PSRT_27

    Scenario: 27 Execute verifyPaymentNotice request
        Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition FK_PA and where value ('6') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        And wait 5 seconds for expiration
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
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
        And EC new version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: 27 Execute activatePaymentNotice request
        Given the 27 Execute verifyPaymentNotice request scenario executed successfully
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header />
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
            <paymentAmount>15.00</paymentAmount>
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
            <transferAmount>15.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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
            <amount>15.00</amount>
            <paymentNote>responseFull3Transfers</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response


    Scenario: 27 Define sendPaymentOutcome
        Given the 27 Execute activatePaymentNotice request scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
            </paf:paSendRTRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And nodo-dei-pagamenti has config parameter scheduler.jobName_paSendRt.enabled set to false
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
        #And job paSendRt triggered after 6 seconds
        And wait 10 seconds for expiration
        Then check outcome is OK of sendPaymentOutcome response
        # DB Check
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NOTICE_GENERATED,NOTICE_SENT,PAYING,PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3

    Scenario: 27 clean paSendRt queue
        Given the 27 Define sendPaymentOutcome scenario executed successfully
        When job paSendRt triggered after 5 seconds
        And wait 10 seconds for expiration

    @runnable @pippoalf
    Scenario: 27 job paSendRt
        Given the 27 Define sendPaymentOutcome scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
            </paf:paSendRTRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paSendRT
        And nodo-dei-pagamenti has config parameter scheduler.jobName_paSendRt.enabled set to true
        When job paSendRt triggered after 6 seconds
        And wait 15 seconds for expiration
        Then checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And restore initial configurations

    # PSRT_29

    Scenario: 29 Execute verifyPaymentNotice request
        Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition FK_PA and where value ('6','8') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        And wait 5 seconds for expiration
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
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
        And EC new version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: 29 Execute activatePaymentNotice request
        Given the 29 Execute verifyPaymentNotice request scenario executed successfully
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
            <transferAmount>5.00</transferAmount>
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
            <transferAmount>2.00</transferAmount>
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
            <paymentNote>responseFull3Transfers</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: 29 trigger PollerAnnulli
        Given the 29 Execute activatePaymentNotice request scenario executed successfully
        When job mod3CancelV2 triggered after 6 seconds
        Then wait 5 seconds for expiration

    Scenario: 29 Define sendPaymentOutcome
        Given the 29 trigger PollerAnnulli scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
            </paf:paSendRTRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And nodo-dei-pagamenti has config parameter scheduler.jobName_paSendRt.enabled set to false
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
            <fee>8.00</fee>
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
        #And job paSendRt triggered after 6 seconds
        And wait 10 seconds for expiration
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response
        # DB Check
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NOTICE_GENERATED,NOTICE_SENT,PAYING,PAID,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value PAYING,INSERTED,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3

    Scenario: 29 clean paSendRt queue
        Given the 29 Define sendPaymentOutcome scenario executed successfully
        When job paSendRt triggered after 5 seconds
        And wait 10 seconds for expiration

    
    Scenario: 29 job paSendRt
        Given the 29 Define sendPaymentOutcome scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTRes>
            </paf:paSendRTRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paSendRT
        And nodo-dei-pagamenti has config parameter scheduler.jobName_paSendRt.enabled set to true
        When job paSendRt triggered after 6 seconds
        And wait 15 seconds for expiration
        Then checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And restore initial configurations