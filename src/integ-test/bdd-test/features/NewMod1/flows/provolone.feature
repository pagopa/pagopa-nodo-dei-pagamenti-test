Feature: syntax checks KO for activatePaymentNoticeV2Request

    Background:
        Given systems up
        And initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            <paymentMethod>PO</paymentMethod>
            <touchPoint>ATM</touchPoint>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    @pippoalf
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given <elem> with <value> in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNoticeV2 response
        Examples:
            | elem                               | value                                                                                                                                                                                                                           | soapUI test            |
            | touchPoint                         | Empty                                                                                                                                                                                                                           | #commissioni evolute 5 |
            | touchPoint                         | None                                                                                                                                                                                                                           | #commissioni evolute 6 |
