Feature: NM3 PA Old without optional

    Background:
        Given systems up

    Scenario: verifyPaymentNotice request
        Given from body verifyPaymentNoticeBody_paOld_noOptional initial XML verifyPaymentNotice
        And from body paaVerificaRPT_noOptional initial XML paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response


    Scenario: activatePaymentNotice request
        Given the verifyPaymentNotice request scenario executed successfully
        And from body activatePaymentNoticeBody_paOld_noOptional initial XML activatePaymentNotice
        And from body paaAttivaRPT_noOptional initial XML paaAttivaRPT
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    @noOptional
    Scenario: sendPaymentOutcome request
        Given the activatePaymentNotice request scenario executed successfully
        And from body sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response