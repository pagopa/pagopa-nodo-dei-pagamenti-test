Feature: Semantic checks for verificaBollettino - OK 1396

    Background:
        Given systems up

    @ALL @PRIMITIVE @NM3 @NM3VBLSEMOK @NM3VBLSEMOK_1
    Scenario: Execute verificaBollttino [SEM_VB_10]
        Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
            | idPSP | idBrokerPSP | idChannel                    | password   | ccPost    | noticeNumber |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #ccPoste# | 312#iuv#     |
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
