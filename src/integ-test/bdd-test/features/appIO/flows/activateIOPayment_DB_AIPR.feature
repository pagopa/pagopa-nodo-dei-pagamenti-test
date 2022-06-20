Feature: DB checks for activateIOPayment primitive

    Background:
        Given systems up
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activateIOPaymentReq>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
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

    Scenario: Execute activateIOPaymentReq request
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: Check correctness POSITION_ACTIVATE table [DB_AIPR_01]
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $activateIOPayment.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.noticeNumber of the record at column NOTICE_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.dueDate of the record at column DUE_DATE of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Check correctness POSITION_SERVICE table [DB_AIPR_02]
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $activateIOPaymentResponse.paymentDescription of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.companyName of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.officeName of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Check correctness POSITION_SERVICE table [DB_AIPR_03]
        Given the Execute activateIOPaymentReq request scenario executed successfully
        And save activateIOPayment response in activateIOPayment_first
        And random idempotencyKey having 70000000001 as idPSP in activateIOPayment
        And noticeNumber with $activateIOPayment.noticeNumber in activateIOPayment
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is KO of activateIOPayment response
        And checks the value $activateIOPayment_firstResponse.paymentDescription of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment_firstResponse.companyName of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment_firstResponse.officeName of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Check correctness POSITION_PAYMENT_PLAN table [DB_AIPR_04]
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_PLAN retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.dueDate of the record at column DUE_DATE of the table POSITION_PAYMENT_PLAN retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT_PLAN retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Check correctness POSITION_TRANSFER table [DB_AIPR_05]
        Given initial XML paGetPayment
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
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>77777777777</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>77777777777</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>10.00</transferAmount>
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
        And the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value $paGetPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPaymentResponse.IBAN of the record at column IBAN of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.paymentAmount of the record at column AMOUNT of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.remittanceInformation of the record at column REMITTANCE_INFORMATION retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.transferCategory of the record at column TRANSFER_CATEGORY of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $paGetPayment.idTransfer of the record at column TRANSFER_IDENTIFIER of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO

    #Scenario: Check correctness POSITION_SUBJECT table [DB_AIPR_06]
        #Given the Execute activateIOPaymentReq request scenario executed successfully
        #Then checks the value $activateIOPayment.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value $activateIOPayment.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value $activateIOPayment.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value $activateIOPayment.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value $activateIOPayment.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value $activateIOPayment.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value $activateIOPayment.city of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value $activateIOPayment.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value $activateIOPayment.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value $activateIOPayment.e-mail of the record at column EMAIL of the table POSITION_SUBJECT of the table POSITION_SUBJECT retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Check correctness POSITION_PAYMENT table [DB_AIPR_07]
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
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Check correctness POSITION_PAYMENT_STATUS table [DB_AIPR_08]
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Check correctness POSITION_PAYMENT_STATUS_SNAPSHOT table [DB_AIPR_09]
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Check correctness POSITION_STATUS table [DB_AIPR_10]
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Check correctness POSITION_STATUS_SNAPSHOT table [DB_AIPR_11]
        Given the Execute activateIOPaymentReq request scenario executed successfully
        Then checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO

