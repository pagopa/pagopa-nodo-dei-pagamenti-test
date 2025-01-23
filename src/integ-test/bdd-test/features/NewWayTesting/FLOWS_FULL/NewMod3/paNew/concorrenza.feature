Feature: NM3 flows PA New con concorrenza

    Background:
        Given systems up


    # AccessiConcorrenziali 3c_ACT_SPO
    # outcome1 == 'KO' and faultCode1 == 'PPT_PAGAMENTO_DUPLICATO' and outcome2 == 'KO' and faultCode2 == 'PPT_TOKEN_SCADUTO':
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_1
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment -> mod3CancelV1  spo+ & activate in pararallel mode-> KO PPT_TOKEN_SCADUTO  (OLD_NM3-3A)
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
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 20 ms delay
        Then check outcome is OK of sendPaymentOutcome response
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNotice response

        #elif outcome2 == 'KO' and faultCode2 == 'PPT_TOKEN_SCADUTO_KO' and outcome1 == 'OK':

