Feature: semantic check for activatePaymentNoticeReq regarding idempotency - use idempotency

    Background:
        Given systems up
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
            <expirationTime>6000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        #And nodo-dei-pagamenti has config parameter idempotencyKey set to true

    # Activate Phase 1
    Scenario: Execute activatePaymentNotice request
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response



    # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO SEM_APNR_21.1]
    @runnable @lazy
    Scenario: Execute again activatePaymentNotice request right after expirationTime has passed
        #Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
        Given the Execute activatePaymentNotice request scenario executed successfully
        And wait 8 seconds for expiration
        And expirationTime with 1000 in activatePaymentNotice
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
