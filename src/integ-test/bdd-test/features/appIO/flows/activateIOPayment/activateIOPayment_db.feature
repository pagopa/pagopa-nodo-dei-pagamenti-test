Feature: DB checks for activateIOPayment primitive 1

    Background:
        Given systems up
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:activateIOPaymentReq>
                        <idPSP>#psp_AGID#</idPSP>
                        <idBrokerPSP>#broker_AGID#</idBrokerPSP>
                        <idChannel>#canale_AGID#</idChannel>
                        <password>pwdpwdpwd</password>
                        <!--Optional:-->
                        <idempotencyKey>#idempotency_key#</idempotencyKey>
                        <qrCode>
                            <fiscalCode>#creditor_institution_code#</fiscalCode>
                            <noticeNumber>#notice_number#</noticeNumber>
                        </qrCode>
                        <!--Optional:-->
                        <expirationTime>12345</expirationTime>
                        <amount>70.00</amount>
                        <!--Optional:-->
                        <dueDate>2021-12-12</dueDate>
                        <!--Optional:-->
                        <paymentNote>test</paymentNote>
                        <!--Optional:-->
                        <payer>
                            <uniqueIdentifier>
                                <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                                <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
                            </uniqueIdentifier>
                            <fullName>name</fullName>
                            <!--Optional:-->
                            <streetName>street</streetName>
                            <!--Optional:-->
                            <civicNumber>civic</civicNumber>
                            <!--Optional:-->
                            <postalCode>code</postalCode>
                            <!--Optional:-->
                            <city>city</city>
                            <!--Optional:-->
                            <stateProvinceRegion>state</stateProvinceRegion>
                            <!--Optional:-->
                            <country>IT</country>
                            <!--Optional:-->
                            <e-mail>test.prova@gmail.com</e-mail>
                        </payer>
                    </nod:activateIOPaymentReq>
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
                                    <transferAmount>3.00</transferAmount>
                                    <fiscalCodePA>77777777777</fiscalCodePA>
                                    <IBAN>IT45R0760103200000000001016</IBAN>
                                    <remittanceInformation>testPaGetPayment</remittanceInformation>
                                    <transferCategory>paGetPaymentTest</transferCategory>
                                </transfer>
                                <transfer>
                                    <idTransfer>2</idTransfer>
                                    <transferAmount>3.00</transferAmount>
                                    <fiscalCodePA>77777777777</fiscalCodePA>
                                    <IBAN>IT45R0760103200000000001016</IBAN>
                                    <remittanceInformation>testPaGetPayment</remittanceInformation>
                                    <transferCategory>paGetPaymentTest</transferCategory>
                                </transfer>
                                <transfer>
                                    <idTransfer>3</idTransfer>
                                    <transferAmount>4.00</transferAmount>
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

    Scenario: Execute activateIOPaymentReq request
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
    
    @runnable
    # [DB_AIPR_01]
    Scenario: Check correctness POSITION_ACTIVATE table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $activateIOPayment.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.noticeNumber of the record at column NOTICE_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.dueDate of the record at column DUE_DATE of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
    
    @runnable
    # [DB_AIPR_02]
    Scenario: Check correctness POSITION_SERVICE table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $activateIOPaymentResponse.paymentDescription of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.companyName of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.officeName of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        #And checks the value $paGetPayment.e-mail of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
    
    @runnable
    # [DB_AIPR_03]
    Scenario: Check correctness POSITION_SERVICE table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        And save activateIOPayment response in activateIOPayment_first
        And random idempotencyKey having AGID_01 as idPSP in activateIOPayment
        And noticeNumber with $activateIOPayment.noticeNumber in activateIOPayment
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is KO of activateIOPayment response
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        #And checks the value $paGetPayment.e-mail of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
    
    @runnable
    # [DB_AIPR_04]
    Scenario: Check correctness POSITION_PAYMENT_PLAN table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_PLAN retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.dueDate of the record at column DUE_DATE of the table POSITION_PAYMENT_PLAN retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.paymentAmount of the record at column AMOUNT of the table POSITION_PAYMENT_PLAN retrived by the query payment_status on db nodo_online under macro AppIO
    
    @runnable
    # [DB_AIPR_05]
    Scenario: Check correctness POSITION_TRANSFER table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.IBAN of the record at column IBAN of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.transferAmount of the record at column AMOUNT of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.remittanceInformation of the record at column REMITTANCE_INFORMATION of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.transferCategory of the record at column TRANSFER_CATEGORY of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.idTransfer of the record at column TRANSFER_IDENTIFIER of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
    
    @runnable
    # [DB_AIPR_06]
    Scenario: Check correctness POSITION_SUBJECT table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $paGetPayment.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        And checks the value $paGetPayment.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        #And checks the value $paGetPayment.e-mail of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
    @runnable
    # [DB_AIPR_07]
    Scenario: Check correctness POSITION_PAYMENT table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value N of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    
    @runnable
    # [DB_AIPR_08]
    Scenario: Check correctness POSITION_PAYMENT_STATUS table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
   
    @runnable
    # [DB_AIPR_09]
    Scenario: Check correctness POSITION_PAYMENT_STATUS_SNAPSHOT table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    
    @runnable
    # [DB_AIPR_10]
    Scenario: Check correctness POSITION_STATUS table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    
    @runnable
    # [DB_AIPR_11]
    Scenario: Check correctness POSITION_STATUS_SNAPSHOT table
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO

