Feature: process tests for retry on a cancelled PAYING transaction [Activate_blocco_14]

    Background:
        Given systems up
        And EC old version
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>#notice_number_old#</noticeNumber>
            </qrCode>
            <expirationTime>2000</expirationTime>
            <amount>10.00</amount>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    #activate phase1
    Scenario: Execute activatePaymentNotice1 request
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice1
        And saving activatePaymentNotice request in activatePaymentNotice1


    #pollerAnnulli phase
    Scenario: Execute pollerAnnulli job
        Given the Execute activatePaymentNotice1 request scenario executed successfully
        When job mod3CancelV1 triggered after 6 seconds
        And wait 10 seconds for expiration


    #activate phase2
    @runnable
    Scenario: Execute activatePaymentNotice2 request
        Given the Execute pollerAnnulli job scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>$activatePaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <amount>10.00</amount>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice2
        And saving activatePaymentNotice request in activatePaymentNotice2
        And checks the value PAYING, CANCELLED_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_payment_status_1 on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_payment_status_2 on db nodo_online under macro NewMod3
        And checks the value CANCELLED_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_payment_status_1 on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_payment_status_2 on db nodo_online under macro NewMod3
        And checks the value PAYING, INSERTED, PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query position_status_1 on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_status_1 on db nodo_online under macro NewMod3
        
