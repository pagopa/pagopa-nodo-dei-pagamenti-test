Feature: PRO_ANNULLO_06

    Background:
        Given systems up

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 6000
        And nodo-dei-pagamenti has config parameter scheduler.cancelIOPaymentActorMinutesToBack set to 1
        And nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to true
        And initial XML verifyPaymentNotice
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
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
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
                <password>$verifyPaymentNotice.password</password>
                <!--Optional:-->
                <idempotencyKey>#idempotency_key#</idempotencyKey>
                <qrCode>
                    <fiscalCode>#creditor_institution_code#</fiscalCode>
                    <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
                </qrCode>
                <!--Optional:-->
                <expirationTime>6000</expirationTime>
                <amount>10.00</amount>
                <!--Optional:-->
                <dueDate>2021-12-12</dueDate>
                <!--Optional:-->
                <paymentNote>responseFull</paymentNote>
                <!--Optional:-->
                <payer>
                    <uniqueIdentifier>
                    <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                    <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
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
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        And job annullamentoRptMaiRichiesteDaPm triggered after 80 seconds
        #And wait 130 seconds for expiration
        And wait until the update to the new state for the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        Then check outcome is OK of activateIOPayment response
        And checks the value PAYING, CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYING, INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
 
 @runnable @dependentread @dependentwrite @lazy       
    Scenario: Execute activateIOPayment1 (Phase 3) [PRO_ANNULLO_06]
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        And wait 10 seconds for expiration
        Then check outcome is OK of activateIOPayment response
        And checks the value PAYING, CANCELLED, PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value CANCELLED, PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYING, INSERTED, PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        # check correctness POSITION_TRANSFER table
        And checks the value Y, N of the record at column VALID of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro AppIO
        And restore initial configurations