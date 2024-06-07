Feature: NMU flows PA Old con pagamento KO

    Background:
        Given systems up


    @ALL @NMU @NMUPAOLD @NMUPAOLDPAGKO @NMUPAOLDPAGKO_1 @after
    Scenario: NMU flow KO, FLOW con PA Old e PSP vp1: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, closeV2+ con resp KO perché manca la RPT -> annulla il token, BIZ-, nodoInviaRPT -> paInviaRT-, BIZ- (NMU-5)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        And from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 312#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #id_broker_psp#                               |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Node did not receive RPT yet of v2/closepayment response
        When job mod3CancelV1 triggered after 6 seconds
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#               |
            | identificativoStazioneRichiedente | #id_station_old#                              |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10                           |
            | dataEsecuzionePagamento           | 2016-09-16                                    |
            | importoTotaleDaVersare            | $activatePaymentNoticeV2.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                        |
            | codiceContestoPagamento           | $activatePaymentNoticeV2Response.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNoticeV2.amount               |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                               |
            | identificativoStazioneIntermediarioPA | #id_station_old#                              |
            | identificativoDominio                 | #creditor_institution_code#                   |
            | identificativoUnivocoVersamento       | 12$iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeV2Response.paymentToken |
            | password                              | #password#                                    |
            | identificativoPSP                     | #psp_AGID#                                    |
            | identificativoIntermediarioPSP        | #broker_AGID#                                 |
            | identificativoCanale                  | #canale_AGID_02#                              |
            | rpt                                   | $rptAttachment                                |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response



    @after
    Scenario: After restore
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'N', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL