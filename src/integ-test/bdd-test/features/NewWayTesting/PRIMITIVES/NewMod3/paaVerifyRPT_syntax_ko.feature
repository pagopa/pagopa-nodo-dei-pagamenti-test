Feature: check syntax KO for paaVerificaRPTRes 1380

    Background:
        Given systems up

    @ALL @PRIMITIVE @NM3 @NM3PAVRPTSNTKO @NM3PAVRPTSNTKO_1
    Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_full initial XML paaVerificaRPT
            | esito                    | OK                          |
            | importoSingoloVersamento | 1.00                        |
            | ibanAccredito            | IT45R0760103200000000001016 |
            | causaleVersamento        | paaVerificaRPT              |
        And <tag> with <tag_value> in paaVerificaRPT
        And if esito is KO set fault to None in paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends soap verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of verifyPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of verifyPaymentNotice response
        Examples:
            | tag                                   | tag_value                                                                                                                                     | soapUI test   |
            | soapenv:Body                          | None                                                                                                                                          | SIN_PVRPTR_02 |
            | soapenv:Body                          | Empty                                                                                                                                         | SIN_PVRPTR_03 |
            | ws:paaVerificaRPTRisposta             | None                                                                                                                                          | SIN_PVRPTR_04 |
            | ws:paaVerificaRPTRisposta             | RemoveParent                                                                                                                                  | SIN_PVRPTR_05 |
            | ws:paaVerificaRPTRisposta             | Empty                                                                                                                                         | SIN_PVRPTR_06 |
            | esito                                 | None                                                                                                                                          | SIN_PVRPTR_07 |
            | esito                                 | Empty                                                                                                                                         | SIN_PVRPTR_08 |
            | esito                                 | prova                                                                                                                                         | SIN_PVRPTR_09 |
            | datiPagamentoPA                       | None                                                                                                                                          | SIN_PVRPTR_11 |
            | datiPagamentoPA                       | RemoveParent                                                                                                                                  | SIN_PVRPTR_12 |
            | datiPagamentoPA                       | Empty                                                                                                                                         | SIN_PVRPTR_13 |
            | importoSingoloVersamento              | None                                                                                                                                          | SIN_PVRPTR_14 |
            | importoSingoloVersamento              | Empty                                                                                                                                         | SIN_PVRPTR_15 |
            | importoSingoloVersamento              | 105,1234                                                                                                                                      | SIN_PVRPTR_16 |
            | importoSingoloVersamento              | 105,2                                                                                                                                         | SIN_PVRPTR_17 |
            | importoSingoloVersamento              | 105,256                                                                                                                                       | SIN_PVRPTR_17 |
            | importoSingoloVersamento              | 12ad45rtyu78hj56                                                                                                                              | SIN_PVRPTR_18 |
            | ibanAccredito                         | None                                                                                                                                          | SIN_PVRPTR_19 |
            | ibanAccredito                         | Empty                                                                                                                                         | SIN_PVRPTR_20 |
            | ibanAccredito                         | llpKVR96sxH3YSZJWewdpG0L4SmAgBp3SHhP                                                                                                          | SIN_PVRPTR_21 |
            | bicAccredito                          | Empty                                                                                                                                         | SIN_PVRPTR_23 |
            | bicAccredito                          | 09rCLPr                                                                                                                                       | SIN_PVRPTR_24 |
            | bicAccredito                          | fY5u4rjEv                                                                                                                                     | SIN_PVRPTR_24 |
            | bicAccredito                          | SF4ukrEcsc2S                                                                                                                                  | SIN_PVRPTR_24 |
            | enteBeneficiario                      | RemoveParent                                                                                                                                  | SIN_PVRPTR_26 |
            | enteBeneficiario                      | Empty                                                                                                                                         | SIN_PVRPTR_27 |
            | pag:identificativoUnivocoBeneficiario | None                                                                                                                                          | SIN_PVRPTR_28 |
            | pag:identificativoUnivocoBeneficiario | RemoveParent                                                                                                                                  | SIN_PVRPTR_29 |
            | pag:identificativoUnivocoBeneficiario | Empty                                                                                                                                         | SIN_PVRPTR_30 |
            | pag:tipoIdentificativoUnivoco         | None                                                                                                                                          | SIN_PVRPTR_31 |
            | pag:tipoIdentificativoUnivoco         | Empty                                                                                                                                         | SIN_PVRPTR_32 |
            | pag:tipoIdentificativoUnivoco         | W                                                                                                                                             | SIN_PVRPTR_33 |
            | pag:tipoIdentificativoUnivoco         | GG                                                                                                                                            | SIN_PVRPTR_34 |
            | pag:codiceIdentificativoUnivoco       | None                                                                                                                                          | SIN_PVRPTR_35 |
            | pag:codiceIdentificativoUnivoco       | Empty                                                                                                                                         | SIN_PVRPTR_36 |
            | pag:codiceIdentificativoUnivoco       | aqs41D94P1BE9FYYU                                                                                                                             | SIN_PVRPTR_37 |
            | pag:denominazioneBeneficiario         | None                                                                                                                                          | SIN_PVRPTR_38 |
            | pag:denominazioneBeneficiario         | Empty                                                                                                                                         | SIN_PVRPTR_39 |
            | pag:denominazioneBeneficiario         | n07sBU01xx8FYhQ1rLXdCi6X0hlZ9fyI4npmVn0XSNIXnqThaMVZ4iDfmrw3Jck9T7iDQgM                                                                       | SIN_PVRPTR_40 |
            | pag:codiceUnitOperBeneficiario        | Empty                                                                                                                                         | SIN_PVRPTR_42 |
            | pag:codiceUnitOperBeneficiario        | vN9VNPz7NqFp3XpTrGw6uqXSpFsVwHmLxSRQ                                                                                                          | SIN_PVRPTR_43 |
            | pag:denomUnitOperBeneficiario         | Empty                                                                                                                                         | SIN_PVRPTR_45 |
            | pag:denomUnitOperBeneficiario         | 9w5Wg9acGLtILqCa6QwiscDbjJFpTi36w475Off7NAxS31uEnWiVN0SQh12xTUKl23P9kUF                                                                       | SIN_PVRPTR_46 |
            | pag:indirizzoBeneficiario             | Empty                                                                                                                                         | SIN_PVRPTR_48 |
            | pag:indirizzoBeneficiario             | Gd5pcvCyr6cp4QjTtYfzUC1kJ9ahQYmT0XtHcgfWQEbtnV7U4aoFb1XgoSAhW8bkD9wndKB                                                                       | SIN_PVRPTR_49 |
            | pag:civicoBeneficiario                | Empty                                                                                                                                         | SIN_PVRPTR_51 |
            | pag:civicoBeneficiario                | uvWjRNIKgwlykuSYZ                                                                                                                             | SIN_PVRPTR_52 |
            | pag:capBeneficiario                   | Empty                                                                                                                                         | SIN_PVRPTR_54 |
            | pag:capBeneficiario                   | uvWjRNIKgwlykuSYZ                                                                                                                             | SIN_PVRPTR_55 |
            | pag:localitaBeneficiario              | Empty                                                                                                                                         | SIN_PVRPTR_57 |
            | pag:localitaBeneficiario              | JcGmMhGsOtwaHHhylTsKjCEBLaGjNVUKEsMM                                                                                                          | SIN_PVRPTR_58 |
            | pag:provinciaBeneficiario             | Empty                                                                                                                                         | SIN_PVRPTR_60 |
            | pag:provinciaBeneficiario             | abc123435e5r34hjgfb3456okd3546a2mp2k                                                                                                          | SIN_PVRPTR_61 |
            | pag:nazioneBeneficiario               | Empty                                                                                                                                         | SIN_PVRPTR_63 |
            | pag:nazioneBeneficiario               | 1A                                                                                                                                            | SIN_PVRPTR_64 |
            | pag:nazioneBeneficiario               | 1                                                                                                                                             | SIN_PVRPTR_64 |
            | pag:nazioneBeneficiario               | E                                                                                                                                             | SIN_PVRPTR_64 |
            | credenzialiPagatore                   | Empty                                                                                                                                         | SIN_PVRPTR_66 |
            | credenzialiPagatore                   | 12AS57rjifijoi245685asdas1568wa48467                                                                                                          | SIN_PVRPTR_67 |
            | causaleVersamento                     | None                                                                                                                                          | SIN_PVRPTR_68 |
            | causaleVersamento                     | Empty                                                                                                                                         | SIN_PVRPTR_69 |
            | causaleVersamento                     | CXYFD9jxEWpaefYPBMGaWHbDBIeU01JMraSQJ7VKHnfWT75DaLXvAPEcV7TDFfThv4u56iGvFT86Ui0ma9EVs1kRk5ETNjGc281weayrfiiHauaJfSNTDxqMONb7tN3PkkgBcn1gJxr6Y | SIN_PVRPTR_70 |


    @ALL @PRIMITIVE @NM3 @NM3PAVRPTSNTKO @NM3PAVRPTSNTKO_2
    Scenario: missing faultBean for esito KO [SIN_PVRPTR_10]
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_KO_noFaultBean initial XML paaVerificaRPT
            | esito | KO |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends soap verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of verifyPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of verifyPaymentNotice response