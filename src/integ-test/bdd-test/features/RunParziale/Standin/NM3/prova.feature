Feature: happy flow with Stand In on and PSP no POSTE

    Background:
        Given systems up

    # Lo scopo di questo test è verificare, a seguito di un flusso passante per stazione di standin,
    # che sia presente il parametro opzionale standin=true nelle response verso il psp, dato che il canale è flaggato a Y su FLAG_STANDIN.
    # Inoltre, dato che anche la stazione sarà flaggata a Y su FLAG_STANDIN, ci aspettiamo di ritrovarci il campo opzionale standin=true, dentro la receipt inviata all'EC
    # dalla paSendRT.
    Scenario: Execute verifyPaymentNotice request
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter VERSIONE_PRIMITIVE = '2', with where condition OBJ_ID = '129' under macro update_query on db nodo_cfg
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'Y', with where condition OBJ_ID = '1380001' under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
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
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paVerifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <paf:paVerifyPaymentNoticeRes>
                    <outcome>OK</outcome>
                    <paymentList>
                        <!--1 to 5 repetitions:-->
                        <paymentOptionDescription>
                            <amount>10.00</amount>
                            <options>EQ</options>
                            <!--Optional:-->
                            <dueDate>2021-12-31</dueDate>
                            <!--Optional:-->
                            <detailDescription>test</detailDescription>
                            <allCCP>1</allCCP>
                        </paymentOptionDescription>
                    </paymentList>
                    <!--Optional:-->
                    <paymentDescription>test</paymentDescription>
                    <!--Optional:-->
                    <fiscalCodePA>#fiscalCodePA#</fiscalCodePA>
                    <!--Optional:-->
                    <companyName>company</companyName>
                    <!--Optional:-->
                    <officeName>office</officeName>
                    </paf:paVerifyPaymentNoticeRes>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        

    # Define primitive paGetPayment
    Scenario: activatePaymentNotice request
        Given the Execute verifyPaymentNotice request scenario executed successfully
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
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
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
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
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter IP = 'CIAO', with where condition OBJ_ID = '1160001' under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds

    @standin
    # Define primitive sendPaymentOutcome
    Scenario: Define sendPaymentOutcome
        Given the activatePaymentNotice request scenario executed successfully
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
        Then check outcome is OK of sendPaymentOutcome response
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter IP = '10.70.66.200', with where condition OBJ_ID = '1160001' under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        # And wait 5 seconds for expiration

        # And execution query position_transfer to get value on the table POSITION_RECEIPT_RECIPIENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        # And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_transfer on db nodo_online under macro NewMod3
        # And execution query position_status_n to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns STATUS under macro NewMod3 with db name nodo_online
        # And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        # And checks the value NOTICE_GENERATED,NOTICE_SENT,PAYING,PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        # And execution query position_transfer to get value on the table POSITION_PAYMENT_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        # And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # And execution query position_transfer to get value on the table POSITION_STATUS, with the columns STATUS under macro NewMod3 with db name nodo_online
        # And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query position_status_n on db nodo_online under macro NewMod3
        # And execution query position_status_n to get value on the table POSITION_STATUS_SNAPSHOT, with the columns STATUS under macro NewMod3 with db name nodo_online
        # And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        
        # And checks the value 0 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
        # And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_status_n on db nodo_online under macro NewMod3
    
        # # DB Checks for POSITION_PAYMENT
        # And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # # DB Checks for POSITION_RECEIPT
        # And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # # DB Checks for POSITION_RECEIPT_XML
        # And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # # DB Checks for POSITION_RECEIPT_RECIPIENT
        # And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
