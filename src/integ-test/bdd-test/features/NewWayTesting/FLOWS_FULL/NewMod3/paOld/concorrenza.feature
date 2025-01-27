Feature: NM3 flows PA Old con concorrenza

    Background:
        Given systems up

    # AccessiConcorrenziali 3a_ACT_SPO
    # ACT -> SPO+  (ACT: OK - SPO: KO PPT_SEMANTICA  Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_1
    Scenario: NM3 flow OK, FLOW: activate -> mod3CancelV1 -> activate & spo+ in pararallel mode-> KO PPT_SEMANTICA  (OLD_NM3-1A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 10 ms delay
        Then check outcome is OK of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response





    # AccessiConcorrenziali 3a_ACT_SPO
    # SPO+ -> ACT (ACT: KO  PPT_PAGAMENTO_DUPLICATO - SPO: KO PPT_TOKEN_SCADUTO)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_2
    Scenario: NM3 flow OK, FLOW: activate -> mod3CancelV1 -> spo+ & activate  in pararallel mode-> KO PPT_SEMANTICA  (OLD_NM3-1A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And from body with datatable horizontal paaAttivaRPT_delay_noOptional initial XML paaAttivaRPT
            | delay | esito | importoSingoloVersamento |
            | 1000  | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 50 ms delay
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response






    # AccessiConcorrenziali 3b_ACT_SPO
    # ACT -> SPO- (ACT: OK - SPO: PPT_SEMANTICA Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_3
    Scenario: NM3 flow OK, FLOW: activate -> mod3CancelV1 ->  activate & spo- in pararallel mode-> KO PPT_TOKEN_SCADUTO  (OLD_NM3-2A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 1 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 50 ms delay
        Then check outcome is OK of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response




    # AccessiConcorrenziali 3b_ACT_SPO
    # SPO- -> ACT (ACT: OK - SPO: PPT_TOKEN_SCADUTO_KO)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_4
    Scenario: NM3 flow OK, FLOW: activate -> mod3CancelV1 -> spo- & activate in pararallel mode-> KO PPT_TOKEN_SCADUTO  (OLD_NM3-2A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 10 ms delay
        Then check outcome is OK of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response






    # AccessiConcorrenziali 3e_ACT_SPO
    # ACT -> SPO+ (ACT:KO - SPO: PPT_SEMANTICA Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_5
    Scenario: NM3 flow OK, FLOW: activate -> mod3CancelV1 -> activate & spo+ in pararallel mode-> KO PPT_SEMANTICA  (OLD_NM3-5A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | $activatePaymentNotice_1Request.noticeNumber | 9.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        And from body with datatable horizontal paaAttivaRPT_KO initial XML paaAttivaRPT
            | faultCode             | faultString          | id                              | description                       | esito |
            | PAA_SINTASSI_EXTRAXSD | errore sintattico PA | #creditor_institution_code_old# | Errore sintattico emesso dalla PA | KO    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 80 ms delay
        Then check outcome is KO of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response






    # AccessiConcorrenziali 3e_ACT_SPO
    # SPO+ - ACT (ACT:OK - SPO: PPT_TOKEN_SCADUTO)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_6
    Scenario: NM3 flow OK, FLOW: activate -> mod3CancelV1 -> activate & spo+ in pararallel mode-> KO PPT_TOKEN_SCADUTO  (OLD_NM3-5A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | $activatePaymentNotice_1Request.noticeNumber | 9.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        And from body with datatable horizontal paaAttivaRPT_KO initial XML paaAttivaRPT
            | faultCode             | faultString          | id                              | description                       | esito |
            | PAA_SINTASSI_EXTRAXSD | errore sintattico PA | #creditor_institution_code_old# | Errore sintattico emesso dalla PA | KO    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 0 ms delay
        Then check outcome is KO of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response