Feature: BUG_fullName_CarattereSpeciale 1087

    Background:
        Given systems up


    @ALL @prova
    Scenario: activatePaymentNotice --> paGetPayment with special character
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo BenvegnÃ¹                 |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response