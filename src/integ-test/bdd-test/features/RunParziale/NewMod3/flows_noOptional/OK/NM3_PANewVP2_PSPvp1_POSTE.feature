Feature: NM3 PA New without optional

    Background:
        Given systems up

    Scenario: verificaBollettino request
        Given from body verificaBollettino_paNewVP2_noOptional initial XML verificaBollettino
        And from body paVerifyPaymentNotice_noOptional initial XML paVerifyPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response


    Scenario: activatePaymentNotice request
        Given the verificaBollettino request scenario executed successfully
        And from body activatePaymentNoticeBody_paNewVP2_noOptional initial XML activatePaymentNotice
        And from body paGetPaymentV2_noOptional initial XML paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    @noOptional
    Scenario: sendPaymentOutcome request
        Given the activatePaymentNotice request scenario executed successfully
        And from body sendPaymentOutcomeBody_POSTE_noOptional initial XML sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response