Feature: check semantic paaVerifyRPT - KO 1379

    Background:
        Given systems up

    @ALL @PRIMITIVE @NM3 @NM3PAVRPTSEMKO @NM3PAVRPTSEMKO_1
    Scenario Outline: semantic check on paaVerificaRPTRes
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_full initial XML paaVerificaRPT
            | esito                    | OK                          |
            | importoSingoloVersamento | 1.00                        |
            | ibanAccredito            | IT45R0760103200000000001016 |
            | causaleVersamento        | paaVerificaRPT              |
        And <tag> with <tag_value> in paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends soap verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of verifyPaymentNotice response
        And check faultCode is PPT_IBAN_NON_CENSITO of verifyPaymentNotice response
        Examples:
            | tag           | tag_value                   | soapUI test   |
            | ibanAccredito | IT40R0000000000000000300009 | SEM_PVRPTR_01 |
