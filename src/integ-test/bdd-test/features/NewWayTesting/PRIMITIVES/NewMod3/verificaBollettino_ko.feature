Feature: NM3 verifyPaymentNotice KO


    Background:
        Given systems up



    @ALL @PRIMITIVE @NM3 @NM3VBLPVNRSNTKO @NM3VBLPVNRSNTKO_1
    Scenario: NM3 PaNEW verificaBollettino -> activate -> verificaBollettino KO con PPT_PAGAMENTO_IN_CORSO (OLD_NM3-7M)
        Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
            | outcome            | OK                          |
            | amount             | 10.00                       |
            | options            | EQ                          |
            | allCCP             | false                       |
            | paymentDescription | Pagamento di Test           |
            | fiscalCodePA       | #creditor_institution_code# |
            | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is KO of verificaBollettino response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of verificaBollettino response





    @ALL @PRIMITIVE @NM3 @NM3VBLPVNRSNTKO @NM3VBLPVNRSNTKO_2
    Scenario: NM3 PaOLD verificaBollettino -> con override paaVerificaRPT KO e PAA_SEMANTICA -> verificaBollettino con KO e PPT_ERRORE_EMESSO_DA_PAA (OLD_NM3-23M)
        Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_KO initial XML paaVerificaRPT
            | faultCode   | PAA_SEMANTICA         |
            | faultString | chiamata da rifiutare |
            | esito       | KO                    |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is KO of verificaBollettino response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verificaBollettino response
        And wait 3 seconds for expiration
        And verify 0 record for the table VERIFICA_BOLLETTINO retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                     |
            | NOTICE_ID  | $verificaBollettino.noticeNumber |
            | CCPOST     | $verificaBollettino.ccPost       |






    @ALL @PRIMITIVE @NM3VERIFICABOL_3 @NM3
    Scenario: NM3 PaOLD verificaBollettino con ccPost #ccPoste_noIBAN# -> verificaBollettino con KO e PPT_IBAN_ACCREDITO (OLD_NM3-24M)
        Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost           | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste_noIBAN# | 312#iuv#     |
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is KO of verificaBollettino response
        And check faultCode is PPT_IBAN_ACCREDITO of verificaBollettino response
        And wait 3 seconds for expiration
        And verify 0 record for the table VERIFICA_BOLLETTINO retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                     |
            | NOTICE_ID  | $verificaBollettino.noticeNumber |
            | CCPOST     | $verificaBollettino.ccPost       |






    @ALL @PRIMITIVE @NM3VERIFICABOL_4 @NM3
    Scenario: NM3 PaOLD verificaBollettino con ccPost #ccPoste_noIBAN# -> con override paaVerificaRPT KO e PAA_SEMANTICA -> verificaBollettino con KO e PPT_ERRORE_EMESSO_DA_PAA (OLD_NM3-25M)
        Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost           | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste_noIBAN# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_KO initial XML paaVerificaRPT
            | faultCode   | PAA_SEMANTICA         |
            | faultString | chiamata da rifiutare |
            | esito       | KO                    |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is KO of verificaBollettino response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verificaBollettino response
        And wait 3 seconds for expiration
        And verify 0 record for the table VERIFICA_BOLLETTINO retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                     |
            | NOTICE_ID  | $verificaBollettino.noticeNumber |
            | CCPOST     | $verificaBollettino.ccPost       |