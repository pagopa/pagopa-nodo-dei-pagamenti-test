Feature: Check semantic payment status 1287

    Background:
        Given systems up
        

    Scenario: Execute verifyPaymentNotice
        Given initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header />
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>#notice_number_old#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    #activate phase
    Scenario: Execute activatePaymentNotice
        Given the Execute verifyPaymentNotice scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>$verifyPaymentNotice.idPSP</idPSP>
            <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
            <idChannel>$verifyPaymentNotice.idChannel</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <!--expirationTime>6000</expirationTime-->
            <amount>10.00</amount>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

@runnable
    Scenario: Verify  in POSITION_STATUS table
        Given the Execute activatePaymentNotice scenario executed successfully
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
            <outcome>KO</outcome>
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
        #And RPT not recived
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And checks the value PAYING, INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING, INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING, FAILED_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value FAILED_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3

    # UNA VOLTA OTTIMIZZATO SI Pùò FARE UNO SCENARIO OUTLINE

    # [SEM_SPO_14]
    #Scenario: Verify PAID in POSITION_STATUS_SNAPSHOT table
        #Given the Initialize sendPaymentOutcome (Phase 2) scenario executed successfully
        #And outcome with OK in sendPaymentOutcome
        #And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        #When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        #And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        # TODO: QUALI SONO I CAMPI DA CONTROLLARE?
        # And checks the value {values} of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3

    # [SEM_SPO_15]
    #Scenario: Verify FAILED in POSITION_STATUS_SNAPSHOT table
        #Given the Execute activatePaymentNotice (Phase 1) scenario executed successfully
        #And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        #And outcome with KO in sendPaymentOutcome
        #When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        #And checks the value FAILED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        # TODO: QUALI SONO I CAMPI DA CONTROLLARE?
        # And checks the value {values} of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3


    # [SEM_SPO_20 PT1]
    #Scenario: SEM_SPO_20_PT1
        #Given EC new version
        #And initial XML paGetPayment
            #"""

            #"""
        #When nodo-dei-pagamenti sends paGetPayment to EC
        #Then check outcome is OK of paGetPayment response

    # [SEM_SPO_20 PT2]
    #Scenario: Verify INSERTED in POSITION_STATUS_SNAPSHOT table with PA new version
        #Given the SEM_SPO_20_PT1 request scenario executed successfully
        #And api-config executes the sql QUERY_DA_INSERIRE (controlla se è PAYING)
        #And outcome with KO in sendPaymentOutcome
        #When PSP sends sendPaymentOutcome request to nodo-dei-pagamenti
        #Then check lastPayment is true of paGetPayment response
        #And api-config executes the sql QUERY_DA_INSERIRE (controlla se è INSERTED)
        #And TODO: SCRIVERE PARTE TANTI RECORD PER OGNI CAMBIO DI STATO

    # [SEM_SPO_21]
    #Scenario: Verify NOTIFIED in POSITION_STATUS_SNAPSHOT table
        #Given the SEM_SPO_20_PT1 request scenario executed successfully
        #And api-config executes the sql QUERY_DA_INSERIRE (controlla se è PAYING)
        #And outcome with OK in sendPaymentOutcome
        #When PSP sends sendPaymentOutcome request to nodo-dei-pagamenti
        #Then api-config executes the sql QUERY_DA_INSERIRE (controlla se è NOTIFIED)
        #And TODO: SCRIVERE PARTE TANTI RECORD PER OGNI CAMBIO DI STATO