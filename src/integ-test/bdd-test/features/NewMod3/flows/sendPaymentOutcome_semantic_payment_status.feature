Feature: Check semantic payment status

    Background:
        Given systems up
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:verifyPaymentNoticeReq>
                        <idPSP>${psp}</idPSP>
                        <idBrokerPSP>${intermediarioPSP}</idBrokerPSP>
                        <idChannel>${canale3}</idChannel>
                        <password>${password}</password>
                        <qrCode>
                            <fiscalCode>${qrCodeCF}</fiscalCode>
                            <noticeNumber>002${#TestCase#iuv}</noticeNumber>
                        </qrCode>
                    </nod:verifyPaymentNoticeReq>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:sendPaymentOutcomeReq>
                        <idPSP>${psp}</idPSP>
                        <idBrokerPSP>${intermediarioPSP}</idBrokerPSP>
                        <idChannel>${canale3}</idChannel>
                        <password>${password}</password>
                        <paymentToken>8f4aa4d917404037bc3ba23130906c52</paymentToken>
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

    #PHASE1
    Scenario: Execute activatePaymentNotice request
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    # UNA VOLTA OTTIMIZZATO SI Pùò FARE UNO SCENARIO OUTLINE

    # [SEM_SPO_14]
    Scenario: Verify PAID in POSITION_STATUS_SNAPSHOT table
    Given the Execute activatePaymentNotice request scenario executed successfully
    And api-config executes the sql QUERY_DA_INSERIRE (controlla se è PAYING)
    And outcome with OK in sendPaymentOutcome 
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then api-config executes the sql QUERY_DA_INSERIRE (controlla se è PAID)
    And TODO: SCRIVERE PARTE TANTI RECORD PER OGNI CAMBIO DI STATO

    # [SEM_SPO_15]
    Scenario: Verify FAILED in POSITION_STATUS_SNAPSHOT table
    Given the Execute activatePaymentNotice request scenario executed successfully
    And api-config executes the sql QUERY_DA_INSERIRE (controlla se è PAYING)
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then api-config executes the sql QUERY_DA_INSERIRE (controlla se è FAILED)
    And TODO: SCRIVERE PARTE TANTI RECORD PER OGNI CAMBIO DI STATO

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