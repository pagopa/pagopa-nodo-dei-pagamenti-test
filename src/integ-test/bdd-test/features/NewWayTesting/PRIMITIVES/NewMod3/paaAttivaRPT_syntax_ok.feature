Feature: check syntax OK for paaAttivaRPT 1378

    Background:
        Given systems up

    @ALL @PRIMITIVE @NM3 @NM3PAARPTSNTOK @NM3PAARPTSNTOK_1
    Scenario Outline: syntax check on paaAttivaRPTRes
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  |
        And from body with datatable vertical paaAttivaRPT_complete initial XML paaAttivaRPT
            | esito                       | OK           |
            | importoSingoloVersamento    | 2.00         |
            | codiceIdentificativoUnivoco | ${stz}       |
            | denominazioneBeneficiario   | ${intermPsp} |
            | codiceUnitOperBeneficiario  | ${can}       |
        And <tag> with <tag_value> in paaAttivaRPT
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Examples:
            | tag                            | tag_value | soapUI test   |
            | soapenv:Header                 | None      | SIN_PARPTR_01 |
            | bicAccredito                   | None      | SIN_PARPTR_22 |
            | enteBeneficiario               | None      | SIN_PARPTR_25 |
            | pag:codiceUnitOperBeneficiario | None      | SIN_PARPTR_41 |
            | pag:denomUnitOperBeneficiario  | None      | SIN_PARPTR_44 |
            | pag:indirizzoBeneficiario      | None      | SIN_PARPTR_47 |
            | pag:civicoBeneficiario         | None      | SIN_PARPTR_50 |
            | pag:capBeneficiario            | None      | SIN_PARPTR_53 |
            | pag:localitaBeneficiario       | None      | SIN_PARPTR_56 |
            | pag:provinciaBeneficiario      | None      | SIN_PARPTR_59 |
            | pag:nazioneBeneficiario        | None      | SIN_PARPTR_62 |
            | credenzialiPagatore            | None      | SIN_PARPTR_65 |