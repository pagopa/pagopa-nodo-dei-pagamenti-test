Feature: Semantic checks for verificaBollettino - OK [SEM_VB_15] 1397

    Background:
        Given systems up

    @ALL @PRIMITIVE @NM3 @NM3VBLSEMOK @NM3VBLSEMOK_2
    Scenario: Check ccPost associates with two PA
        Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 302#iuv#     |
        And from body with datatable vertical paaVerificaRPT_full initial XML paaVerificaRPT
            | esito                    | OK                       |
            | importoSingoloVersamento | 1.00                     |
            | ibanAccredito            | IT45R0760103200#ccPoste# |
            | causaleVersamento        | pagamentoTest            |
        And pag:indirizzoBeneficiario with 44444444444_05 in paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response