Feature: process tests for paSendRT [PSRT_24]

    Background:
        Given systems up


    Scenario: job refresh pa (1)
        Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with Y, with where condition OBJ_ID and where value ('13','1201') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds

    Scenario: Execute verifyPaymentNotice request
        Given the job refresh pa (1) scenario executed successfully
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


    Scenario: Define sendPaymentOutcome
        Given the Execute activatePaymentNotice request scenario executed successfully
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
        Then check outcome is OK of sendPaymentOutcome response

    #Scenario: trigger jobs paSendRt
    #Given the Execute sendPaymentOutcome request scenario executed successfully
    #When job paSendRt triggered after 5 seconds
    #Then verify the HTTP status code of paSendRt response is 200


    Scenario: DB check + db update
        Given the Define sendPaymentOutcome scenario executed successfully
        And wait 15 seconds for expiration
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

    @runnable
    Scenario: job refresh pa (2)
        Given the DB check + db update scenario executed successfully
        And update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition OBJ_ID and where value ('13','1201') under macro update_query on db nodo_cfg
        Then refresh job ALL triggered after 10 seconds


