Feature: NM3 flows PA New con concorrenza

    Background:
        Given systems up



    # AccessiConcorrenziali 3c_ACT_SPO
    # ACT -> SPO+ (ACT: OK SPO+: KO PPT_SEMANTICA Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_1
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment -> mod3CancelV1 -> activate & spo+ in pararallel mode-> KO PPT_SEMANTICA  (OLD_NM3-3A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And from body with datatable vertical paGetPayment_delay_full initial XML paGetPayment
            | delay                       | 1000                        |
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 750 ms delay
        Then check outcome is OK of activatePaymentNotice response
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response


    # AccessiConcorrenziali 3c_ACT_SPO
    # SPO+ -> ACT (ACT: KO PPT_PAGAMENTO_DUPLICATO - SPO+: KO PPT_TOKEN_SCADUTO)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_2
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment -> mod3CancelV1 -> spo+ & activate in pararallel mode-> KO PPT_TOKEN_SCADUTO  (OLD_NM3-3A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 10 ms delay
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNotice response
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response








    # AccessiConcorrenziali 3d_ACT_SPO
    # ACT -> SPO- (ACT: OK - SPO+ -> KO PPT_SEMANTICA Activation pending on position )
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_3
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment -> mod3CancelV1 -> activate & spo- in pararallel mode-> KO PPT_SEMANTICA  (OLD_NM3-4A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 20 ms delay
        Then check outcome is OK of activatePaymentNotice response
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response





    # AccessiConcorrenziali 3d_ACT_SPO
    # ACT -> SPO- (ACT: OK - SPO-: KO PPT_TOKEN_SCADUTO_KO Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_4
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment -> mod3CancelV1 -> spo- & activate in pararallel mode-> KO PPT_TOKEN_SCADUTO_KO  (OLD_NM3-4A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 20 ms delay
        Then check outcome is OK of activatePaymentNotice response
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response