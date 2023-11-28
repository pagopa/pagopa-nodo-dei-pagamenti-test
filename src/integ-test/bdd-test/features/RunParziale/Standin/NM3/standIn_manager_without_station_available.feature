Feature: stand in manager without station available for stand in

    Background:
        Given systems up

    # Define primitive paGetPayment
    Scenario: activatePaymentNotice request
        Given delete through the query {query_name} into the table STAND_IN_STATIONS with where condition {where_condition} and where value {valore} under macro {macro} on db {db_name}
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>02$iuv</creditorReferenceId>
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
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>$verifyPaymentNotice.fiscalCode</fiscalCode>
            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        #And check standin is true of activatePaymentNotice response


    # Define primitive sendPaymentOutcome
    Scenario: Define sendPaymentOutcome
        Given the activatePaymentNotice request scenario executed successfully
        And initial XML paSendRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header />
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
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
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
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And wait 15 seconds for expiration
        Then check outcome is OK of sendPaymentOutcome response

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
        
        And checks the value 0 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
    
    @PG32
    Scenario: job paSendRt
        Given the Define sendPaymentOutcome scenario executed successfully
        When job paSendRt triggered after 6 seconds
        And wait 15 seconds for expiration

        # DB Checks for POSITION_PAYMENT
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # DB Checks for POSITION_RECEIPT
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # DB Checks for POSITION_RECEIPT_XML
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # DB Checks for POSITION_RECEIPT_RECIPIENT
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # RE
        # And execution query re_paSendRT to get value on the table RE, with the columns PAYLOAD under macro NewMod3 with db name re
        # And through the query re_paSendRT retrieve xml PAYLOAD at position 0 and save it under the key paSendRT
        #And check value $paSendRT.standin is equal to value true
        #And nodo-dei-pagamenti has config parameter invioReceiptStandin set to N