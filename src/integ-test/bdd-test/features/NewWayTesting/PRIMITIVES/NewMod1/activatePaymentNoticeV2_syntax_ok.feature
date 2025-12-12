Feature: syntax checks OK for activatePaymentNoticeV2Request 959

    Background:


    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SYN_OK @NMU_ACTV2_SYN_OK_1
    Scenario: Check valid URL in WSDL namespace
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_idempotency_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | idempotencyKey          | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | #alpha_idempotency_key# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response


    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SYN_OK @NMU_ACTV2_SYN_OK_2
    Scenario Outline: Check OK response on missing optional fields
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And <elem> with <value> in activatePaymentNoticeV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Examples:
            | elem           | value | soapUI test            |
            | idempotencyKey | None  | SIN_APNV2_18           |
            | expirationTime | None  | SIN_APNV2_35           |
            | dueDate        | None  | SIN_APNV2_44           |
            | paymentNote    | None  | SIN_APNV2_47           |
            | paymentMethod  | None  | #commissioni evolute 1 |
            | touchPoint     | None  | #commissioni evolute 2 |


    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SYN_OK @NMU_ACTV2_SYN_OK_3
    Scenario Outline: Check OK response on missing optional fields (stazione con versione primitive 2)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And <elem> with <value> in activatePaymentNoticeV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Examples:
            | elem           | value | soapUI test    |
            | idempotencyKey | None  | SIN_APNV2_18.1 |
            | expirationTime | None  | SIN_APNV2_35.1 |
            | dueDate        | None  | SIN_APNV2_44.1 |
            | paymentNote    | None  | SIN_APNV2_47.1 |