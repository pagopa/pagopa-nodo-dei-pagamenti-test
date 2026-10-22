Feature: flow tests for demandPaymentNotice 923

    #Questi test per ora non funzionano, dovrebbe essere il PG-106 e funzioneranno solo dopo il merge. Attualmente questa implementazione non è ancora su postgres (23/08/24)

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM4 @NM4SINDPNROK @NM4SINDPNROK_1
    Scenario: tests for demandPaymentNotice
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable horizontal paDemandPaymentNotice initial XML paDemandPaymentNotice
            | outcome | fiscalCode                  | noticeNumber | amount |
            | OK      | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And datiSpecificiServizio with Y2lhbyBjYXJv in demandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends soap demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SINDPNROK @NM4SINDPNROK_2
    Scenario: tests for demandPaymentNotice
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00041              |
        And from body with datatable horizontal paDemandPaymentNotice initial XML paDemandPaymentNotice
            | outcome | fiscalCode                  | noticeNumber | amount |
            | OK      | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And datiSpecificiServizio with PGNpYW8+Y2FybzwvY2lhbz4= in demandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends soap demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response