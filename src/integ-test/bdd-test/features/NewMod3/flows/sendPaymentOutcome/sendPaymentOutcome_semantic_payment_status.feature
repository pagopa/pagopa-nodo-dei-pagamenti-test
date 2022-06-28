Feature: Check semantic payment status

    Background:
        Given systems up

    Scenario: Execute activatePaymentNotice (Phase 1)
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>#notice_number#</noticeNumber>
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

    Scenario: Initialize sendPaymentOutcome (Phase 2)
        Given the Execute activatePaymentNotice (Phase 1) scenario executed successfully
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
            <outcome>OK</outcome>
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>John Doe</fullName>
            <streetName>street</streetName>
            <civicNumber>12</civicNumber>
            <postalCode>89020</postalCode>
            <city>city</city>
            <stateProvinceRegion>MI</stateProvinceRegion>
            <country>IT</country>
            <e-mail>john.doe@test.it</e-mail>
            </payer>
            <applicationDate>2021-10-01</applicationDate>
            <transferDate>2021-10-02</transferDate>
            </details>
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    # UNA VOLTA OTTIMIZZATO SI Pùò FARE UNO SCENARIO OUTLINE

    # [SEM_SPO_14]
    Scenario: Verify PAID in POSITION_STATUS_SNAPSHOT table
        Given the Initialize sendPaymentOutcome (Phase 2) scenario executed successfully
        And outcome with OK in sendPaymentOutcome
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        # TODO: QUALI SONO I CAMPI DA CONTROLLARE?
        # And checks the value {values} of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3

    # [SEM_SPO_15]
    Scenario: Verify FAILED in POSITION_STATUS_SNAPSHOT table
        Given the Execute activatePaymentNotice (Phase 1) scenario executed successfully
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And outcome with KO in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And checks the value FAILED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        # TODO: QUALI SONO I CAMPI DA CONTROLLARE?
        # And checks the value {values} of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3

    # [SEM_SPO_16]
    Scenario: Verify INSERTED in POSITION_STATUS_SNAPSHOT table with PA old version
        Given EC old version
        And the Execute activatePaymentNotice request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        And api-config executes the sql QUERY_DA_INSERIRE (controlla se è PAYING)
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then api-config executes the sql QUERY_DA_INSERIRE (controlla se è INSERTED)
        And TODO: SCRIVERE PARTE TANTI RECORD PER OGNI CAMBIO DI STATO

    # [SEM_SPO_20 PT1]
    Scenario: SEM_SPO_20_PT1
        Given EC new version
        And initial XML paGetPayment
            """

            """
        When nodo-dei-pagamenti sends paGetPayment to EC
        Then check outcome is OK of paGetPayment response

    # [SEM_SPO_20 PT2]
    Scenario: Verify INSERTED in POSITION_STATUS_SNAPSHOT table with PA new version
        Given the SEM_SPO_20_PT1 request scenario executed successfully
        And api-config executes the sql QUERY_DA_INSERIRE (controlla se è PAYING)
        And outcome with KO in sendPaymentOutcome
        When PSP sends sendPaymentOutcome request to nodo-dei-pagamenti
        Then check lastPayment is true of paGetPayment response
        And api-config executes the sql QUERY_DA_INSERIRE (controlla se è INSERTED)
        And TODO: SCRIVERE PARTE TANTI RECORD PER OGNI CAMBIO DI STATO

    # [SEM_SPO_21]
    Scenario: Verify NOTIFIED in POSITION_STATUS_SNAPSHOT table
        Given the SEM_SPO_20_PT1 request scenario executed successfully
        And api-config executes the sql QUERY_DA_INSERIRE (controlla se è PAYING)
        And outcome with OK in sendPaymentOutcome
        When PSP sends sendPaymentOutcome request to nodo-dei-pagamenti
        Then api-config executes the sql QUERY_DA_INSERIRE (controlla se è NOTIFIED)
        And TODO: SCRIVERE PARTE TANTI RECORD PER OGNI CAMBIO DI STATO