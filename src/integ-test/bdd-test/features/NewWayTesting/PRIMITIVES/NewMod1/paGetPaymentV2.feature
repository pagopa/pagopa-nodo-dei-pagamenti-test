Feature: response tests for paGetPaymentV2 967

    Background:
        Given systems up


    @ALL @PRIMITIVE @NMU @NMU_PAGETPAYV2 @NMU_PAGETPAYV2_1
    # KO tests
    Scenario Outline: KO tests
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And <tag> with <value> in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
        Examples:
            | tag                         | value                                                                                                                                                                                                                                                       |
            | outcome                     | None                                                                                                                                                                                                                                                        |
            | outcome                     | Empty                                                                                                                                                                                                                                                       |
            | outcome                     | prova                                                                                                                                                                                                                                                       |
            | creditorReferenceId         | None                                                                                                                                                                                                                                                        |
            | creditorReferenceId         | Empty                                                                                                                                                                                                                                                       |
            | creditorReferenceId         | 123456789012345678901234567890123456                                                                                                                                                                                                                        |
            | paymentAmount               | None                                                                                                                                                                                                                                                        |
            | paymentAmount               | Empty                                                                                                                                                                                                                                                       |
            | paymentAmount               | 0.00                                                                                                                                                                                                                                                        |
            | paymentAmount               | 105,12                                                                                                                                                                                                                                                      |
            | paymentAmount               | 105.2                                                                                                                                                                                                                                                       |
            | paymentAmount               | 105.256                                                                                                                                                                                                                                                     |
            | paymentAmount               | 12ad45rtyu78hj56.44                                                                                                                                                                                                                                         |
            | paymentAmount               | 1000000000.00                                                                                                                                                                                                                                               |
            | dueDate                     | None                                                                                                                                                                                                                                                        |
            | dueDate                     | Empty                                                                                                                                                                                                                                                       |
            | dueDate                     | 20-12-2022                                                                                                                                                                                                                                                  |
            | dueDate                     | 12-20-2022                                                                                                                                                                                                                                                  |
            | dueDate                     | 2022-12-12T12:23:000                                                                                                                                                                                                                                        |
            | retentionDate               | Empty                                                                                                                                                                                                                                                       |
            | retentionDate               | 20-12-2022                                                                                                                                                                                                                                                  |
            | retentionDate               | 2021-12-30T                                                                                                                                                                                                                                                 |
            | retentionDate               | 12-20-2022                                                                                                                                                                                                                                                  |
            | lastPayment                 | Empty                                                                                                                                                                                                                                                       |
            | lastPayment                 | 3                                                                                                                                                                                                                                                           |
            | description                 | None                                                                                                                                                                                                                                                        |
            | description                 | Empty                                                                                                                                                                                                                                                       |
            | description                 | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                               |
            | companyName                 | Empty                                                                                                                                                                                                                                                       |
            | companyName                 | None                                                                                                                                                                                                                                                        |
            | companyName                 | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                               |
            | officeName                  | Empty                                                                                                                                                                                                                                                       |
            | officeName                  | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                               |
            | entityUniqueIdentifierType  | None                                                                                                                                                                                                                                                        |
            | entityUniqueIdentifierType  | Empty                                                                                                                                                                                                                                                       |
            | entityUniqueIdentifierType  | P                                                                                                                                                                                                                                                           |
            | entityUniqueIdentifierValue | None                                                                                                                                                                                                                                                        |
            | entityUniqueIdentifierValue | Empty                                                                                                                                                                                                                                                       |
            | entityUniqueIdentifierValue | 12ftr4567dghfi89k                                                                                                                                                                                                                                           |
            | fullName                    | None                                                                                                                                                                                                                                                        |
            | fullName                    | Empty                                                                                                                                                                                                                                                       |
            | fullName                    | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375                                                                                                                                                                                     |
            | streetName                  | Empty                                                                                                                                                                                                                                                       |
            | streetName                  | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375                                                                                                                                                                                     |
            | civicNumber                 | Empty                                                                                                                                                                                                                                                       |
            | civicNumber                 | 1we345ty67ghjkl78                                                                                                                                                                                                                                           |
            | postalCode                  | Empty                                                                                                                                                                                                                                                       |
            | postalCode                  | 12ftr4567dghfi89k                                                                                                                                                                                                                                           |
            | city                        | Empty                                                                                                                                                                                                                                                       |
            | city                        | 123456mklo12345678901234567890123456                                                                                                                                                                                                                        |
            | stateProvinceRegion         | Empty                                                                                                                                                                                                                                                       |
            | stateProvinceRegion         | 123456mklo12345678901234567890123456                                                                                                                                                                                                                        |
            | country                     | Empty                                                                                                                                                                                                                                                       |
            | country                     | ITA                                                                                                                                                                                                                                                         |
            | country                     | de                                                                                                                                                                                                                                                          |
            | e-mail                      | Empty                                                                                                                                                                                                                                                       |
            | e-mail                      | @provatest.it                                                                                                                                                                                                                                               |
            | e-mail                      | noei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375sanoei38932nfdiou%&ncdoaifer9eukvmptu.it |
            | transferAmount              | None                                                                                                                                                                                                                                                        |
            | transferAmount              | Empty                                                                                                                                                                                                                                                       |
            | transferAmount              | 0.00                                                                                                                                                                                                                                                        |
            | transferAmount              | 10,89                                                                                                                                                                                                                                                       |
            | transferAmount              | 12.456                                                                                                                                                                                                                                                      |
            | transferAmount              | 1.1                                                                                                                                                                                                                                                         |
            | transferAmount              | 1000000000.00                                                                                                                                                                                                                                               |
            | transferAmount              | 60.98                                                                                                                                                                                                                                                       |
            | fiscalCodePA                | None                                                                                                                                                                                                                                                        |
            | fiscalCodePA                | Empty                                                                                                                                                                                                                                                       |
            | fiscalCodePA                | 123409857635                                                                                                                                                                                                                                                |
            | fiscalCodePA                | 123456789rf                                                                                                                                                                                                                                                 |
            | fiscalCodePA                | 152436%&789                                                                                                                                                                                                                                                 |
            | fiscalCodePA                | 17777777477                                                                                                                                                                                                                                                 |
            | fiscalCodePA                | 11111122222                                                                                                                                                                                                                                                 |
            | remittanceInformation       | None                                                                                                                                                                                                                                                        |
            | remittanceInformation       | Empty                                                                                                                                                                                                                                                       |
            | remittanceInformation       | sanoei38932nfdiou0pncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                               |
            | transferCategory            | None                                                                                                                                                                                                                                                        |
            | transferCategory            | Empty                                                                                                                                                                                                                                                       |
            | transferCategory            | sanoei38932nfdiou0pncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                               |
            | soapenv:Body                | None                                                                                                                                                                                                                                                        |
            | soapenv:Body                | RemoveParent                                                                                                                                                                                                                                                |
            | soapenv:Body                | Empty                                                                                                                                                                                                                                                       |
            | data                        | None                                                                                                                                                                                                                                                        |
            | data                        | Empty                                                                                                                                                                                                                                                       |
            | data                        | RemoveParent                                                                                                                                                                                                                                                |
            | debtor                      | RemoveParent                                                                                                                                                                                                                                                |
            | debtor                      | None                                                                                                                                                                                                                                                        |
            | debtor                      | Empty                                                                                                                                                                                                                                                       |
            | IBAN                        | IT45R0760103200000000001016908765432                                                                                                                                                                                                                        |
            | IBAN                        | None                                                                                                                                                                                                                                                        |
            | IBAN                        | Empty                                                                                                                                                                                                                                                       |
            | IBAN                        | IT45R0760103200777777777777                                                                                                                                                                                                                                 |
            | IBAN                        | IT45R0760103200004440551016                                                                                                                                                                                                                                 |
            | idTransfer                  | A                                                                                                                                                                                                                                                           |
            | idTransfer                  | 11                                                                                                                                                                                                                                                          |
            | idTransfer                  | Empty                                                                                                                                                                                                                                                       |
            | idTransfer                  | None                                                                                                                                                                                                                                                        |
            | key                         | None                                                                                                                                                                                                                                                        |
            | mapEntry                    | RemoveParent                                                                                                                                                                                                                                                |
            | metadata                    | RemoveParent                                                                                                                                                                                                                                                |
            | metadata                    | Empty                                                                                                                                                                                                                                                       |
            | transferList                | Empty                                                                                                                                                                                                                                                       |
            | transferList                | None                                                                                                                                                                                                                                                        |
            | transferList                | RemoveParent                                                                                                                                                                                                                                                |
            | uniqueIdentifier            | RemoveParent                                                                                                                                                                                                                                                |
            | uniqueIdentifier            | None                                                                                                                                                                                                                                                        |
            | uniqueIdentifier            | Empty                                                                                                                                                                                                                                                       |
            | paf:paGetPaymentV2Response  | None                                                                                                                                                                                                                                                        |
            | paf:paGetPaymentV2Response  | RemoveParent                                                                                                                                                                                                                                                |
            | transfer                    | None                                                                                                                                                                                                                                                        |
            | transfer                    | Empty                                                                                                                                                                                                                                                       |
            | paymentAmount               | 11.00                                                                                                                                                                                                                                                       |
            | value                       | None                                                                                                                                                                                                                                                        |


    @ALL @PRIMITIVE @NMU @NMU_PAGETPAYV2 @NMU_PAGETPAYV2_2
    # OK tests
    Scenario Outline: OK tests
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And <tag> with <value> in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Examples:
            | tag                 | value                                 |
            | retentionDate       | None                                  |
            | fiscalCodePA        | #creditor_institution_code_secondary# |
            | metadata            | None                                  |
            | city                | None                                  |
            | country             | None                                  |
            | e-mail              | None                                  |
            | lastPayment         | None                                  |
            | officeName          | None                                  |
            | postalCode          | None                                  |
            | stateProvinceRegion | None                                  |
            | streetName          | None                                  |
            | civicNumber         | None                                  |

    @ALL @PRIMITIVE @NMU @NMU_PAGETPAYV2 @NMU_PAGETPAYV2_3
    # KO test 6 transfers
    Scenario: KO test
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 12.00  |
        And from body with datatable vertical paGetPaymentV2_6_transfer_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 12.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 2.00                                |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA4               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA5               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA6               | $activatePaymentNoticeV2.fiscalCode |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response


    @ALL @PRIMITIVE @NMU @NMU_PAGETPAYV2 @NMU_PAGETPAYV2_4
    # KO test 16 mapEntry inside transfers
    Scenario: KO test
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_16_inside_mapEntry initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 12.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 2.00                                |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA4               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA5               | $activatePaymentNoticeV2.fiscalCode |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_PAGETPAYV2 @NMU_PAGETPAYV2_5
    # KO test 16 mapEntry outside trasfer
    Scenario: KO test
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_16_outside_mapEntry initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 12.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 2.00                                |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA4               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA5               | $activatePaymentNoticeV2.fiscalCode |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_PAGETPAYV2 @NMU_PAGETPAYV2_6
    # OK test different amount and paymentAmount
    Scenario: OK test
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 11.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_PAGETPAYV2 @NMU_PAGETPAYV2_7
    # KO test idTransfer not inside enumeration
    Scenario: KO test
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_3_transfer_incomplete initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 5.00                                |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_PAGETPAYV2 @NMU_PAGETPAYV2_8
    # KO test response KO without faultBean
    Scenario: KO test
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_no_faultBean initial XML paGetPaymentV2
            | outcome | KO |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
