Feature: check syntax OK for paaVerificaRPTRes 1381

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM3 @NM3NM3PAVRPTSNT0OK @NM3NM3PAVRPTSNTOK_1
    Scenario Outline: check syntax OK paaVerificaRPTRes
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
        Then check outcome is OK of verifyPaymentNotice response
        Examples:
            | tag                            | tag_value | soapUI test   |
            | soapenv:Header                 | None      | SIN_PVRPTR_01 |
            | bicAccredito                   | None      | SIN_PVRPTR_22 |
            | enteBeneficiario               | None      | SIN_PVRPTR_25 |
            | pag:codiceUnitOperBeneficiario | None      | SIN_PVRPTR_41 |
            | pag:denomUnitOperBeneficiario  | None      | SIN_PVRPTR_44 |
            | pag:indirizzoBeneficiario      | None      | SIN_PVRPTR_47 |
            | pag:civicoBeneficiario         | None      | SIN_PVRPTR_50 |
            | pag:capBeneficiario            | None      | SIN_PVRPTR_53 |
            | pag:localitaBeneficiario       | None      | SIN_PVRPTR_56 |
            | pag:provinciaBeneficiario      | None      | SIN_PVRPTR_59 |
            | pag:nazioneBeneficiario        | None      | SIN_PVRPTR_62 |
            | credenzialiPagatore            | None      | SIN_PVRPTR_65 |
