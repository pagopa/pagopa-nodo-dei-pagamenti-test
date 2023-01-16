Feature: FLUSSO_APIO_33

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
    When AppIO sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

    Scenario: Execute activateIOPayment (Phase 2)
        Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
        And initial XML activateIOPayment
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activateIOPaymentReq>
                    <idPSP>$verifyPaymentNotice.idPSP</idPSP>
                    <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
                    <idChannel>$verifyPaymentNotice.idChannel</idChannel>
                    <password>pwdpwdpwd</password>
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
        When AppIO sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    @check
    Scenario: Execute activateIOPayment1 (Phase 3)
        Given nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to true
        And nodo-dei-pagamenti has config parameter scheduler.cancelIOPaymentActorMinutesToBack set to 1
        And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 1000
        And the Execute activateIOPayment (Phase 2) scenario executed successfully
        When job annullamentoRptMaiRichiesteDaPm triggered after 70 seconds
        And wait 15 seconds for expiration
        And PSP sends soap activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And restore initial configurations
        