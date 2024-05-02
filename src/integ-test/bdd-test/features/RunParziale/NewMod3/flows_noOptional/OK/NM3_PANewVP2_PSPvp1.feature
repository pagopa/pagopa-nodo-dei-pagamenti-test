Feature: NM3 PA New without optional

    Background:
        Given systems up

    Scenario: verifyPaymentNotice request
        Given from body verifyPaymentNoticeBody_paNewVP2_noOptional initial XML verifyPaymentNotice
        And from body paVerifyPaymentNotice_noOptional initial XML paVerifyPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response


    Scenario: activatePaymentNotice request
        Given the verifyPaymentNotice request scenario executed successfully
        And from body activatePaymentNoticeBody_paNewVP2_noOptional initial XML activatePaymentNotice
        And from body paGetPaymentV2_noOptional initial XML paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    @noOptional
    Scenario: sendPaymentOutcome request
        Given the activatePaymentNotice request scenario executed successfully
        And from body sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response