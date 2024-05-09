Feature: NM3 PA Old without optional

    Background:
        Given systems up
    
    Scenario: verificaBollettino request
        Given from body with datatable verificaBollettino_noOptional initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password  | ccPost    | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | pwdpwdpwd | #ccPoste# | 002#iuv#     |
        And from body with datatable paaVerificaRPT_noOptional initial XML paaVerificaRPT
            | esito | importoSingoloVersamento | ibanAccredito               | causaleVersamento                            |
            | OK    | 1.00                     | IT45R0760103200000000001016 | prova/RFDB/$iuv/TESTO/causale del versamento |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response

    @prova
    Scenario: activatePaymentNotice request
        Given the verificaBollettino request scenario executed successfully
        #And from body activatePaymentNoticeBody_paOld_noOptional initial XML activatePaymentNotice
        And from body with datatable activatePaymentNoticeBody_paOld_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 002$iuv      | 10.00  |
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
