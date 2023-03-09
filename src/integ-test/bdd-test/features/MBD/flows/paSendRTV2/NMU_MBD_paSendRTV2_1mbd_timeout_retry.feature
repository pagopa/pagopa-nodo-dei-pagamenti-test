# Il test verifica che la in caso di timeout per la paSendRTV2 sia inserito un record nella tabella POSITION_RETRY_PA_SEND_RT

Feature: flow tests for paSendRTV2 - Marca da bollo
    # Reference document:
    # https://pagopa.atlassian.net/wiki/spaces/PAG/pages/527138945/Analisi+paSendRTV2
    # https://pagopa.atlassian.net/wiki/spaces/PAG/pages/558204362/WIP+A.T.+Gestione+della+marca+da+bollo+digitale+nel+NMU#paSendRTV2
    # https://pagopa.atlassian.net/wiki/spaces/PAG/pages/540967264/PAG-1826+-+Gestione+Marca+da+Bollo+nel+NMU

    Background:
        Given systems up

    Scenario: Execute activatePaymentNoticeV2
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#pspEcommerce#</idPSP>
            <idBrokerPSP>#brokerEcommerce#</idBrokerPSP>
            <idChannel>#canaleEcommerce#</idChannel>
            <password>#password#</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
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
            <!--Optional:-->
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
            <richiestaMarcaDaBollo>
            <hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</hashDocumento>
            <tipoBollo>01</tipoBollo>
            <provinciaResidenza>MI</provinciaResidenza>
            </richiestaMarcaDaBollo>
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

    # define closePaymentV2
    Scenario: closePaymentV2
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "token"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2012-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "12345678"
                },
                "additionalPMInfo": {
                    "origin": "",
                    "user": {
                        "fullName": "John Doe",
                        "type": "F",
                        "fiscalCode": "JHNDOE00A01F205N",
                        "notificationEmail": "john.doe@mail.it",
                        "userId": 1234,
                        "userStatus": 11,
                        "userStatusDescription": "REGISTERED_SPID"
                    }
                }
            }
            """

    # define paSendRTV2
    Scenario: paSendRTV2
        Given initial xml paSendRTV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTV2Response>
            <delay>25000</delay>
            <outcome>OK</outcome>
            </paf:paSendRTV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    # define MBD
    Scenario: Define MBD
        Given initial xml MB
            """
            <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
            <PSP>
            <CodiceFiscale>CF60000000006</CodiceFiscale>
            <Denominazione>#psp#</Denominazione>
            </PSP>
            <IUBD>#iubd#</IUBD>
            <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
            <Importo>5.00</Importo>
            <TipoBollo>01</TipoBollo>
            <ImprontaDocumento>
            <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
            <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
            </ImprontaDocumento>
            <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
            <SignedInfo>
            <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
            <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
            <Reference URI="">
            <Transforms>
            <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
            </Transforms>
            <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
            <DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</DigestValue>
            </Reference>
            </SignedInfo>
            <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
            </Signature>
            </marcaDaBollo>
            """

    # closePayment-v2 phase
    Scenario: Execute a closePayment-v2 request
        Given the Execute activatePaymentNoticeV2 scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And paymentToken with $activatePaymentNoticeV2Response.paymentToken in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then check outcome is OK of v2/closepayment response
        And verify the HTTP status code of v2/closepayment response is 200

    # sendPaymentOutcome phase
    Scenario: Execute sendPaymentOutcomeV2
        Given the Define MBD scenario executed successfully
        And the paSendRTV2 scenario executed successfully
        And MB generation
            """
            $MB
            """
        And the Execute a closePayment-v2 request scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And initial XML sendPaymentOutcomeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentTokens>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            </paymentTokens>
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
            <marcheDaBollo>
            <marcaDaBollo>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            <idTransfer>1</idTransfer>
            <MBDAttachment>$bollo</MBDAttachment>
            </marcaDaBollo>
            </marcheDaBollo>
            </details>
            </nod:sendPaymentOutcomeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And wait 5 seconds for expiration
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response



    # DB check
    Scenario: execute DB check
        Given the Execute sendPaymentOutcomeV2 scenario executed successfully
        And wait 5 seconds for expiration
        Then verify 1 record for the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value $MB.TipoBollo of the record at column TIPO_BOLLO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value BD of the record at column TIPO_ALLEGATO_RICEVUTA of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value $iubd of the record at column IUBD of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value $MB.Importo of the record at column IMPORTO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ORA_ACQUISTO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column INSERTED_BY of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        # RE
        And verify 2 record for the table RE retrived by the query select_paSendRTV2 on db re under macro sendPaymentResultV2
        And checks the value REQ,RESP of the record at column SOTTO_TIPO_EVENTO of the table RE retrived by the query select_paSendRTV2 on db re under macro sendPaymentResultV2
        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_STATUS
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_STATUS_SNAPSHOT
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_RETRY_PA_SEND_RT
        And verify 1 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2

    # inserire i check sul blob in RE per l'xml paSendRTV2
    @test
    # trigger pa send RT retry
    Scenario: Execute paSendRT
        Given the execute DB check scenario executed successfully
        And initial xml paSendRTV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTV2Response>
            <delay>10000</delay>
            <outcome>OK</outcome>
            </paf:paSendRTV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 0 seconds
        And wait 15 seconds for expiration
        Then verify the HTTP status code of paSendRt response is 200

        # DB check 1
        # POSITION_RETRY_PA_SEND_RT
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2