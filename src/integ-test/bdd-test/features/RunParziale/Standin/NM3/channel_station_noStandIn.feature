Feature: happy flow with Stand In on and channel no Stand In

    Background:
        Given systems up

    # Lo scopo di questo test è verificare che il parametro opzionale standin=true non sia presente nelle response verso il psp
    # ma che vengano inviate le receipt dalla paSendRT, dato che il flag invioReceiptStandin sulla config keys è a Y, non contenenti però il parametro opzionale standin=true. 

    Scenario: Execute verifyPaymentNotice request
        Given insert through the query insert_query into the table STAND_IN_STATIONS the fields STATION_CODE with 'irraggiungibile' under macro update_query on db nodo_cfg 
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_STANDIN = 'N', with where condition OBJ_ID = '16647' under macro update_query on db nodo_cfg
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter FLAG_STANDIN = 'N', with where condition OBJ_ID = '129' under macro update_query on db nodo_cfg
        And nodo-dei-pagamenti has config parameter invioReceiptStandin set to true
        And wait 50 seconds for expiration
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
            <noticeNumber>346#iuv#</noticeNumber>
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
        And check standin field not exists in verifyPaymentNotice response
        

    # Define primitive paGetPayment
    Scenario: activatePaymentNotice request
        Given the Execute verifyPaymentNotice request scenario executed successfully
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>46$iuv</creditorReferenceId>
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
        And check standin field not exists in activatePaymentNotice response
        And checks the value Y of the record at column FLAG_STANDIN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3


    @standin
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
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamentin
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

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

        # DB Checks for POSITION_PAYMENT
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # DB Checks for POSITION_RECEIPT
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # DB Checks for POSITION_RECEIPT_XML
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # DB Checks for POSITION_RECEIPT_RECIPIENT
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        
        # RE
        And checks the value Y of the record at column FLAG_STANDIN of the table RE retrived by the query sottoTipoEvento_paVerifyPayment on db re under macro NewMod3
        And checks the value Y of the record at column FLAG_STANDIN of the table RE retrived by the query sottoTipoEvento_paGetPayment on db re under macro NewMod3
        And execution query re_paSendRT_REQ_xml to get value on the table RE, with the columns PAYLOAD under macro NewMod3 with db name re
        And through the query re_paSendRT_REQ_xml retrieve xml PAYLOAD at position 0 and save it under the key paSendRT
        And check payload tag standIn field not exists in $paSendRT
        And check value $paSendRT.idStation is equal to value irraggiungibile
        And verify 2 record for the table RE retrived by the query sottoTipoEvento on db re under macro NewMod3
        And nodo-dei-pagamenti has config parameter invioReceiptStandin set to false
        And delete through the query delete_query into the table STAND_IN_STATIONS with where condition STATION_CODE and where value 'irraggiungibile' under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds