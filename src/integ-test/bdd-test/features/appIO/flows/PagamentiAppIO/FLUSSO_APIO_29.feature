Feature: FLUSSO_APIO_29

    Background:
        Given systems up

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given initial XML verifyPaymentNotice
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
                <idPSP>#psp_AGID#</idPSP>
                <idBrokerPSP>#broker_AGID#</idBrokerPSP>
                <idChannel>#canale_AGID#</idChannel>
                <password>pwdpwdpwd</password>
                <qrCode>
                    <fiscalCode>#creditor_institution_code#</fiscalCode>
                    <noticeNumber>#notice_number#</noticeNumber>
                </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'Y', with where condition OBJ_ID = '13' under macro update_query on db nodo_cfg
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'Y', with where condition OBJ_ID = '1201' under macro update_query on db nodo_cfg
        #When refresh job CONFIG triggered after 10 seconds
        #And wait 15 seconds for expiration
        And AppIO sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: Execute activateIOPayment (Phase 2)
        Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
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
                                    <fiscalCodePA>90000000001</fiscalCodePA>
                                    <IBAN>IT45R0760103200000000001016</IBAN>
                                    <remittanceInformation>testPaGetPayment</remittanceInformation>
                                    <transferCategory>paGetPaymentTest</transferCategory>
                                </transfer>
                                <transfer>
                                    <idTransfer>3</idTransfer>
                                    <transferAmount>4.00</transferAmount>
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
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:activateIOPaymentReq>
                        <idPSP>$verifyPaymentNotice.idPSP</idPSP>
                        <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
                        <idChannel>$verifyPaymentNotice.idChannel</idChannel>
                        <password>$verifyPaymentNotice.password</password>
                        <!--Optional:-->
                        <idempotencyKey>#idempotency_key#</idempotencyKey>
                        <qrCode>
                            <fiscalCode>#creditor_institution_code#</fiscalCode>
                            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
                        </qrCode>
                        <!--Optional:-->
                        <expirationTime>12345</expirationTime>
                        <amount>10.00</amount>
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
        And idempotencyKey with None in activateIOPayment
        And expirationTime with None in activateIOPayment
        And dueDate with None in activateIOPayment
        And payer with None in activateIOPayment
        When AppIO sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
 
    Scenario: Execute nodoInoltroEsitoCarta (Phase 4) 
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
        """
        {
            "RRN":10026669,
            "tipoVersamento":"CP",
            "idPagamento":"$activateIOPaymentResponse.paymentToken",
            "identificativoIntermediario":"#psp#",
            "identificativoPsp":"#psp#",
            "identificativoCanale":"#canale#",
            "importoTotalePagato":10.00,
            "timestampOperazione":"2021-07-09T17:06:03.100+01:00",
            "codiceAutorizzativo":"resOK",
            "esitoTransazioneCarta":"00"
            }
        """
        Then verify the HTTP status code of inoltroEsito/carta response is 200
        And check esito is OK of inoltroEsito/carta response
        And checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        # check correctness of POSITION_PAYMENT table
        And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value CP of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
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
        # check PM_SESSION_DATA table
        And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value 10026669 of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value 00 of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value resOK of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
        And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO

@runnable
    Scenario: Execute sendPaymentOutcome (Phase 5)
        Given the Execute nodoInoltroEsitoCarta (Phase 4) scenario executed successfully
        And initial XMl sendPaymentOutcome
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
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
        And details with None in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        And checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED, PAID, NOTICE_GENERATED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        #And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYING, PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        # check correctness of POSITION_PAYMENT table
        And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $sendPaymentOutcome.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $sendPaymentOutcome.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value CP of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
        # check POSITION_SUBJECT table
        #And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
        # extraction from POSITION_PAYMENT table
        And execution query payment_status to get value on the table POSITION_PAYMENT, with the columns * under macro AppIO with db name nodo_online
        And through the query payment_status retrieve param pa at position 1 and save it under the key pa
        And through the query payment_status retrieve param noticeNumber at position 2 and save it under the key noticeNumber
        And through the query payment_status retrieve param creditorReferenceId at position 3 and save it under the key creditorReferenceId
        And through the query payment_status retrieve param paymentToken at position 4 and save it under the key paymentToken
        And through the query payment_status retrieve param brokerPA at position 5 and save it under the key brokerPA
        And through the query payment_status retrieve param stationPA at position 6 and save it under the key stationPA
        And through the query payment_status retrieve param insertedTimestamp at position 20 and save it under the key insertedTimestamp
        And through the query payment_status retrieve param updatedTimestamp at position 21 and save it under the key updatedTimestamp  
        # check correctness of POSITION_RECEIPT_RECIPIENT table
        And checks the value $pa of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $pa of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $brokerPA of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $stationPA of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
        # TODO: check correctness of POSITION_RECEIPT_RECIPIENT_STATUS table
        And checks the value $pa of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $pa of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $brokerPA of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $stationPA of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value NOTICE_GENERATED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_1 on db nodo_online under macro AppIO
        #check correctness of POSITION_RECEIPT_XML table
        # extraction from POSITION_RECEIPT_RECIPIENT table
        And execution query payment_status to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns * under macro AppIO with db name nodo_online
        And through the query payment_status retrieve param recipientFiscalCode at position 5 and save it under the key recipientFiscalCode
        And through the query payment_status retrieve param recipientBroker at position 6 and save it under the key recipientBroker
        And through the query payment_status retrieve param recipientStation at position 7 and save it under the key recipientStation
        # check correctness of POSITION_RECEIPT_XML table
        And checks the value $pa of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $recipientFiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $recipientBroker of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value $recipientStation of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'N', with where condition OBJ_ID = '13' under macro update_query on db nodo_cfg
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'N', with where condition OBJ_ID = '1201' under macro update_query on db nodo_cfg
        And refresh job PA triggered after 10 seconds
