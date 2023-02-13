Feature: process test for NM3 with spoV2 OK and generation of receipt

    Background:
        Given systems up

    Scenario: Execute verifyPaymentNotice request
        Given initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
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
            <paymentOptionDescription>
            <amount>1.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2021-12-31</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <!--Optional:-->
            <paymentDescription>/RFB/00202200000217527/5.00/TXT/</paymentDescription>
            <!--Optional:-->
            <fiscalCodePA>$verifyPaymentNotice.fiscalCode</fiscalCodePA>
            <!--Optional:-->
            <companyName>company PA</companyName>
            <!--Optional:-->
            <officeName>office PA</officeName>
            </paf:paVerifyPaymentNoticeRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    # ActivateV2 Phase
    Scenario: Execute activatePaymentNotice request
        Given the Execute verifyPaymentNotice request scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310$iuv</noticeNumber>
            </qrCode>
            <!--expirationTime>60000</expirationTime-->
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeReq>
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
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
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
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentResponse

    # Payment Outcome Phase outcome OK
    Scenario: Execute sendPaymentOutcomeV2 request
        Given the Execute activatePaymentNotice request scenario executed successfully
        And initial XML sendPaymentOutcomeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <paymentTokens>
            <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
            </paymentTokens>
            <outcome>OK</outcome>
            <!--Optional:-->
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <primaryCiIncurredFee>2.00</primaryCiIncurredFee>
            <idBundle>idBundleProva</idBundle>
            <idCiBundle>idCiBundleProva</idCiBundle>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
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
            </nod:sendPaymentOutcomeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response

    @test
    # test execution
    Scenario: Execution test DB
        Given the Execute sendPaymentOutcomeV2 request scenario executed successfully
        And PSP waits 5 seconds for expiration
        #POSITION_PAYMENT_STATUS/SNAPSHOT
        And checks the value PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        #POSITION_STATUS/SNAPSHOT
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        #RT
        Then execution query rt to get value on the table RT, with the columns ID_SESSIONE,CCP,IDENT_DOMINIO,IUV,COD_ESITO,DATA_RICEVUTA,DATA_RICHIESTA,ID_RICEVUTA,ID_RICHIESTA,SOMMA_VERSAMENTI,INSERTED_TIMESTAMP,UPDATED_TIMESTAMP,CANALE,ID under macro NewMod3 with db name nodo_online
        And execution query rpt to get value on the table RPT, with the columns CCP,IDENT_DOMINIO,IUV,ID_MSG_RICH,CANALE under macro NewMod3 with db name nodo_online
        And execution query payment_status to get value on the table POSITION_PAYMENT, with the columns AMOUNT,FEE,PAYMENT_TOKEN,NOTICE_ID,PA_FISCAL_CODE,OUTCOME,CHANNEL_ID,PAYMENT_CHANNEL,PAYER_ID,PAYMENT_METHOD,ID,APPLICATION_DATE,CREDITOR_REFERENCE_ID,BROKER_PA_ID,STATION_ID under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And with the query rt check assert beetwen elem CCP in position 1 and elem CCP with position 0 of the query rpt
        And with the query rt check assert beetwen elem IDENT_DOMINIO in position 2 and elem IDENT_DOMINIO with position 1 of the query rpt
        And with the query rt check assert beetwen elem IUV in position 3 and elem IUV with position 2 of the query rpt
        And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And with the query rt check assert beetwen elem ID_RICHIESTA in position 8 and elem ID_MSG_RICH with position 3 of the query rpt
        And with the query rt check assert beetwen elem SOMMA_VERSAMENTI in position 9 and elem AMOUNT with position 0 of the query payment_status
        And with the query rt check assert beetwen elem CANALE in position 12 and elem CANALE with position 4 of the query rpt
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        #RT_VERSAMENTI
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns * under macro NewMod3 with db name nodo_online
        And execution query rpt_versamenti to get value on the table RPT_VERSAMENTI, with the columns s.CAUSALE_VERSAMENTO,s.DATI_SPECIFICI_RISCOSSIONE under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value 1 of the record at column PROGRESSIVO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        #And with the query rt_versamenti check assert beetwen elem IMPORTO_RT in position 1 and elem AMOUNT with position 0 of the query payment_status
        And checks the value ESEGUITO of the record at column ESITO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And with the query rt_versamenti check assert beetwen elem CAUSALE_VERSAMENTO in position 4 and elem CAUSALE_VERSAMENTO with position 0 of the query rpt_versamenti
        And with the query rt_versamenti check assert beetwen elem DATI_SPECIFICI_RISCOSSIONE in position 5 and elem DATI_SPECIFICI_RISCOSSIONE with position 1 of the query rpt_versamenti
        And with the query rt_versamenti check assert beetwen elem COMMISSIONE_APPLICATE_PSP in position 6 and elem FEE with position 1 of the query payment_status
        And with the query rt_versamenti check assert beetwen elem FK_RT in position 7 and elem ID with position 13 of the query rt
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        #POSITION_RECEIPT
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns RECEIPT_ID,s.NOTICE_ID,s.PA_FISCAL_CODE,s.CREDITOR_REFERENCE_ID,s.PAYMENT_TOKEN,s.OUTCOME,s.PAYMENT_AMOUNT,s.DESCRIPTION,s.COMPANY_NAME,s.OFFICE_NAME,s.DEBTOR_ID,s.PSP_ID,s.PSP_COMPANY_NAME,s.PSP_FISCAL_CODE,s.PSP_VAT_NUMBER,s.CHANNEL_ID,s.CHANNEL_DESCRIPTION,s.PAYER_ID,s.PAYMENT_METHOD,s.FEE,s.PAYMENT_DATE_TIME,s.APPLICATION_DATE,s.TRANSFER_DATE,s.METADATA,s.RT_ID,s.FK_POSITION_PAYMENT,s.ID under macro NewMod3 with db name nodo_online
        And execution query position_service to get value on the table POSITION_SERVICE, with the columns DESCRIPTION,COMPANY_NAME,OFFICE_NAME,DEBTOR_ID under macro NewMod3 with db name nodo_online
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE,CODICE_FISCALE,VAT_NUMBER under macro NewMod3 with db name nodo_cfg
        And execution query position_payment_plan to get value on the table POSITION_PAYMENT_PLAN, with the columns METADATA under macro NewMod3 with db name nodo_online
        And with the query position_receipt check assert beetwen elem RECEIPT_ID in position 0 and elem PAYMENT_TOKEN with position 2 of the query payment_status
        And with the query position_receipt check assert beetwen elem NOTICE_ID in position 1 and elem NOTICE_ID with position 3 of the query payment_status
        And with the query position_receipt check assert beetwen elem PA_FISCAL_CODE in position 2 and elem PA_FISCAL_CODE with position 4 of the query payment_status
        And with the query position_receipt check assert beetwen elem CREDITOR_REFERENCE_ID in position 3 and elem CREDITOR_REFERENCE_ID with position 12 of the query payment_status
        And with the query position_receipt check assert beetwen elem PAYMENT_TOKEN in position 4 and elem PAYMENT_TOKEN with position 2 of the query payment_status
        And with the query position_receipt check assert beetwen elem OUTCOME in position 5 and elem OUTCOME with position 5 of the query payment_status
        And with the query position_receipt check assert beetwen elem AMOUNT in position 6 and elem AMOUNT with position 0 of the query payment_status
        And with the query position_receipt check assert beetwen elem DESCRIPTION in position 7 and elem DESCRIPTION with position 0 of the query position_service
        And with the query position_receipt check assert beetwen elem COMPANY_NAME in position 8 and elem COMPANY_NAME with position 1 of the query position_service
        And with the query position_receipt check assert beetwen elem OFFICE_NAME in position 9 and elem OFFICE_NAME with position 2 of the query position_service
        And with the query position_receipt check assert beetwen elem DEBTOR_ID in position 10 and elem DEBTOR_ID with position 3 of the query position_service
        And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And with the query position_receipt check assert beetwen elem PSP_COMPANY_NAME in position 12 and elem PSP_COMPANY_NAME with position 0 of the query psp
        And with the query position_receipt check assert beetwen elem PSP_FISCAL_CODE in position 13 and elem PSP_FISCAL_CODE with position 1 of the query psp
        And with the query position_receipt check assert beetwen elem PSP_VAT_NUMBER in position 14 and elem PSP_VAT_NUMBER with position 2 of the query psp
        And with the query position_receipt check assert beetwen elem CHANNEL_ID in position 15 and elem CHANNEL_ID with position 6 of the query payment_status
        And with the query position_receipt check assert beetwen elem CHANNEL_DESCRIPTION in position 16 and elem PAYMENT_CHANNEL with position 7 of the query payment_status
        And with the query position_receipt check assert beetwen elem PAYER_ID in position 17 and elem PAYER_ID with position 8 of the query payment_status
        And with the query position_receipt check assert beetwen elem PAYMENT_METHOD in position 18 and elem PAYMENT_METHOD with position 9 of the query payment_status
        And with the query position_receipt check assert beetwen elem FEE in position 19 and elem FEE with position 1 of the query payment_status
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And with the query position_receipt check assert beetwen elem APPLICATION_DATE in position 21 and elem APPLICATION_DATE with position 11 of the query payment_status
        And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And with the query position_receipt check assert beetwen elem METADATA in position 23 and elem METADATA with position 0 of the query position_payment_plan
        And with the query position_receipt check assert beetwen elem RT_ID in position 24 and elem METADATA with position 13 of the query rt
        And with the query position_receipt check assert beetwen elem FK_POSITION_PAYMENT in position 25 and elem METADATA with position 10 of the query payment_status
        #RT_XML
        And execution query rt_xml to get value on the table RT_XML, with the columns ID,CCP,IDENT_DOMINIO,IUV,FK_RT,TIPO_FIRMA,XML_CONTENT,INSERTED_TIMESTAMP,UPDATED_TIMESTAMP,ID_SESSIONE under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And with the query rt_xml check assert beetwen elem CCP in position 1 and elem CCP with position 0 of the query rpt
        And with the query rt_xml check assert beetwen elem IDENT_DOMINIO in position 2 and elem IDENT_DOMINIO with position 1 of the query rpt
        And with the query rt_xml check assert beetwen elem iuv in position 3 and elem iuv with position 2 of the query rpt
        And with the query rt_xml check assert beetwen elem FK_RT in position 4 and elem iuv with position 13 of the query rt
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And with the query rt_xml check assert beetwen elem ID_SESSIONE in position 9 and elem iuv with position 0 of the query rt
        #POSITION_RECEIPT_TRANSFER
        And execution query position_receipt_transfer to get value on the table POSITION_RECEIPT_TRANSFER, with the columns FK_POSITION_RECEIPT,s.FK_POSITION_TRANSFER under macro NewMod3 with db name nodo_online
        And execution query position_transfer to get value on the table POSITION_TRANSFER, with the columns ID under macro NewMod3 with db name nodo_online
        And with the query position_receipt_transfer check assert beetwen elem RECEIPT in position 0 and elem ID with position 26 of the query position_receipt
        And verify 1 record for the table POSITION_RECEIPT_TRANSFER retrived by the query position_receipt_transfer on db nodo_online under macro NewMod3
        And with the query position_receipt_transfer check assert beetwen elem TRANSFER in position 1 and elem ID with position 0 of the query position_transfer
        #POSITION_RECEIPT_XML
        And execution query position_receipt_xml to get value on the table POSITION_RECEIPT_XML, with the columns ID,PA_FISCAL_CODE,NOTICE_ID,CREDITOR_REFERENCE_ID,PAYMENT_TOKEN,RECIPIENT_PA_FISCAL_CODE,RECIPIENT_BROKER_PA_ID,RECIPIENT_STATION_ID,XML,INSERTED_TIMESTAMP,FK_POSITION_RECEIPT under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        And with the query position_receipt_xml check assert beetwen elem PA_FISCAL_CODE in position 1 and elem PA_FISCAL_CODE with position 4 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem NOTICE_ID in position 2 and elem NOTICE_ID with position 3 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem CREDITOR_REFERENCE_ID in position 3 and elem CREDITOR_REFERENCE_ID with position 12 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem PAYMENT_TOKEN in position 4 and elem PAYMENT_TOKEN with position 2 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem RECIPIENT_PA_FISCAL_CODE in position 5 and elem PA_FISCAL_CODE with position 4 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem RECIPIENT_BROKER_PA_ID in position 6 and elem RECIPIENT_BROKER_PA_ID with position 13 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem RECIPIENT_STATION_ID in position 7 and elem RECIPIENT_STATION_ID with position 14 of the query payment_status
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        And with the query position_receipt_xml check assert beetwen elem FK_POSITION_RECEIPT in position 10 and elem ID with position 26 of the query position_receipt