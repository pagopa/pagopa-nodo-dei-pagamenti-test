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
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        Given <attribute> set <value> for <elem> in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNoticeV2 response
        Examples:
            | elem             | attribute     | value                                     | soapUI test  |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_APNV2_01 |

    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given <elem> with <value> in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNoticeV2 response
        Examples:
            | elem                               | value                                                                                                                                                                                                                           | soapUI test    |
            | idPSP                              | 123456789012345678901234567890123456                                                                                                                                                                                            | SIN_APNV2_07   |
            | idPSP                              | None                                                                                                                                                                                                                            | SIN_APNV2_05   |
            | idPSP                              | Empty                                                                                                                                                                                                                           | SIN_APNV2_06   |
            | idBrokerPSP                        | 123456789012345678901234567890123456                                                                                                                                                                                            | SIN_APNV2_10   |
            | idBrokerPSP                        | None                                                                                                                                                                                                                            | SIN_APNV2_08   |
            | idBrokerPSP                        | Empty                                                                                                                                                                                                                           | SIN_APNV2_09   |
            | idChannel                          | 123456789012345678901234567890123456                                                                                                                                                                                            | SIN_APNV2_13   |
            | idChannel                          | None                                                                                                                                                                                                                            | SIN_APNV2_11   |
            | idChannel                          | Empty                                                                                                                                                                                                                           | SIN_APNV2_12   |
            | password                           | None                                                                                                                                                                                                                            | SIN_APNV2_14   |
            | password                           | Empty                                                                                                                                                                                                                           | SIN_APNV2_15   |
            | password                           | 1234567                                                                                                                                                                                                                         | SIN_APNV2_16   |
            | password                           | 1234567890123456                                                                                                                                                                                                                | SIN_APNV2_17   |
            | qrCode                             | None                                                                                                                                                                                                                            | SIN_APNV2_23   |
            | qrCode                             | RemoveParent                                                                                                                                                                                                                    | SIN_APNV2_24   |
            | qrCode                             | Empty                                                                                                                                                                                                                           | SIN_APNV2_25   |
            | fiscalCode                         | None                                                                                                                                                                                                                            | SIN_APNV2_26   |
            | fiscalCode                         | Empty                                                                                                                                                                                                                           | SIN_APNV2_27   |
            | fiscalCode                         | 1234567890                                                                                                                                                                                                                      | SIN_APNV2_28   |
            | fiscalCode                         | 123456789012                                                                                                                                                                                                                    | SIN_APNV2_29   |
            | fiscalCode                         | 12345jh%lk9                                                                                                                                                                                                                     | SIN_APNV2_30   |
            | noticeNumber                       | None                                                                                                                                                                                                                            | SIN_APNV2_31   |
            | noticeNumber                       | Empty                                                                                                                                                                                                                           | SIN_APNV2_32   |
            | noticeNumber                       | 12345678901234567                                                                                                                                                                                                               | SIN_APNV2_33   |
            | noticeNumber                       | 1234567890123456789                                                                                                                                                                                                             | SIN_APNV2_33   |
            | noticeNumber                       | 12345678901234567A                                                                                                                                                                                                              | SIN_APNV2_34   |
            | noticeNumber                       | 12345678901234567!                                                                                                                                                                                                              | SIN_APNV2_34   |
            | soapenv:Body                       | None                                                                                                                                                                                                                            | SIN_APNV2_02   |
            | soapenv:Body                       | Empty                                                                                                                                                                                                                           | SIN_APNV2_03   |
            | nod:activatePaymentNoticeV2Request | Empty                                                                                                                                                                                                                           | SIN_APNV2_04   |
            | idempotencyKey                     | Empty                                                                                                                                                                                                                           | SIN_APNV2_19   |
            | idempotencyKey                     | 70000000001.1244565744                                                                                                                                                                                                          | SIN_APNV2_20   |
            | idempotencyKey                     | 70000000001_%244565744                                                                                                                                                                                                          | SIN_APNV2_20   |
            | idempotencyKey                     | 70000000001-1244565744                                                                                                                                                                                                          | SIN_APNV2_20   |
            | idempotencyKey                     | 1244565768_70000000001                                                                                                                                                                                                          | SIN_APNV2_20   |
            | idempotencyKey                     | 1244565744                                                                                                                                                                                                                      | SIN_APNV2_20   |
            | idempotencyKey                     | 700000000011244565744                                                                                                                                                                                                           | SIN_APNV2_20   |
            | idempotencyKey                     | 70000000001_12445657684                                                                                                                                                                                                         | SIN_APNV2_21   |
            | idempotencyKey                     | 70000000001_124456576                                                                                                                                                                                                           | SIN_APNV2_22   |
            | idempotencyKey                     | 700000hj123_1244565767                                                                                                                                                                                                          | SIN_APNV2_22.1 |
            | expirationTime                     | Empty                                                                                                                                                                                                                           | SIN_APNV2_36   |
            | expirationTime                     | 2021-12-12T12:12:12                                                                                                                                                                                                             | SIN_APNV2_37   |
            | expirationTime                     | 48:12:12                                                                                                                                                                                                                        | SIN_APNV2_37   |
            | expirationTime                     | 12:12                                                                                                                                                                                                                           | SIN_APNV2_37   |
            | expirationTime                     | 1800001                                                                                                                                                                                                                         | SIN_APNV2_38   |
            | amount                             | None                                                                                                                                                                                                                            | SIN_APNV2_39   |
            | amount                             | Empty                                                                                                                                                                                                                           | SIN_APNV2_40   |
            | amount                             | 10,00                                                                                                                                                                                                                           | SIN_APNV2_41   |
            | amount                             | 10.1                                                                                                                                                                                                                            | SIN_APNV2_42   |
            | amount                             | 10.123                                                                                                                                                                                                                          | SIN_APNV2_42   |
            | amount                             | 10.120                                                                                                                                                                                                                          | SIN_APNV2_42   |
            | amount                             | 8881234567.00                                                                                                                                                                                                                   | SIN_APNV2_43   |
            | dueDate                            | Empty                                                                                                                                                                                                                           | SIN_APNV2_45   |
            | dueDate                            | 12-28-2021                                                                                                                                                                                                                      | SIN_APNV2_46   |
            | dueDate                            | 12-12-21                                                                                                                                                                                                                        | SIN_APNV2_46   |
            | dueDate                            | 2021-03-06T15:25:32                                                                                                                                                                                                             | SIN_APNV2_46   |
            | paymentNote                        | Empty                                                                                                                                                                                                                           | SIN_APNV2_48   |
            | paymentNote                        | test di prova sulla lunghezza superiore a 140 caratteri per il parametro della primitiva activatePaymentNoticeV2Request paymentNote prova prova pro activatePaymentNoticeV2Request paymentNote prova prova pro activatePaymentN | SIN_APNV2_49   |