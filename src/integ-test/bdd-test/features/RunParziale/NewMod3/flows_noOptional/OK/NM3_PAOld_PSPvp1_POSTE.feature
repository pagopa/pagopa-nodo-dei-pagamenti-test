Feature: NM3 PA Old without optional

    Background:
        Given systems up

    Scenario: verificaBollettino request
        Given from body verificaBollettino_paOld_noOptional initial XML verificaBollettino
        And from body paaVerificaRPT_noOptional initial XML paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response


    Scenario: activatePaymentNotice request
        Given the verificaBollettino request scenario executed successfully
        And from body activatePaymentNoticeBody_paOld_noOptional initial XML activatePaymentNotice
        And from body paaAttivaRPT_noOptional initial XML paaAttivaRPT
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    @noOptional
    Scenario: sendPaymentOutcome request
        Given the activatePaymentNotice request scenario executed successfully
        And from body sendPaymentOutcomeBody_POSTE_noOptional initial XML sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response