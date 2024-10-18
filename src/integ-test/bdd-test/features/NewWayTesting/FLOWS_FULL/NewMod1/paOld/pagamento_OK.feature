Feature: NMU flows PA Old con pagamento OK

  Background:
    Given systems up


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_1 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT , closeV2+ -> pspNotifyPayment con additionalPaymentInformations, spo+ -> paInviaRT+, BIZ+ e SPRv2+ (NMU-8)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
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
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcome                  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,2021-07-09T17:06:03,12,00,2,123456,11223344                     |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcome REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
    And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeReq.idChannel xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
    And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
    # sendPaymentOutcome RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
    And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_2 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1 e Travaso CP, FLOW: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPayment con creditCardPayment, spo+ -> paInviaRT+, BIZ+ e SPRv2+ (NMU-9)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
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
    And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2                                             |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcome                  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,2021-07-09T17:06:03,12,00,2,123456,11223344                     |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.creditCardPayment.rrn xml check value 11223344 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.outcomePaymentGateway xml check value 00 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.totalAmount xml check value 12 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.fee xml check value 2 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.timestampOperation xml check value NotNone in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.authorizationCode xml check value 123456 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.paymentGateway xml check value 00 in position 0
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcome REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
    And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeReq.idChannel xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
    And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
    # sendPaymentOutcome RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
    And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_3 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1 e Travaso PPAL, FLOW: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPayment con paypalPayment, spo+ -> paInviaRT+, BIZ+ e SPRv2+ (NMU-10)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_PPAL initial json v2/closepayment
      | token1                | $activatePaymentNoticeV2Response.paymentToken |
      | outcome               | OK                                            |
      | idPSP                 | #psp#                                         |
      | idBrokerPSP           | #id_broker_psp#                               |
      | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | paymentMethod         | PPAL                                          |
      | transactionId         | #transaction_id#                              |
      | totalAmountExt        | 12                                            |
      | feeExt                | 2                                             |
      | primaryCiIncurredFee  | 1                                             |
      | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
      | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
      | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
      | transId               | #transaction_id#                              |
      | pspTransactionId      | #psp_transaction_id#                          |
      | totalAmount1          | 12                                            |
      | fee1                  | 2                                             |
      | timestampOperation1   | 2021-07-09T17:06:03                           |
    And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2                                             |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcome                  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                       |
      | TRANSACTION_ID | $transaction_id                                                                             |
      | KEY            | Token,Tipo versamento,pspTransactionId,timestampOperation,totalAmount,transactionId,fee     |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,PPAL,NotNone,2021-07-09T17:06:03,12,NotNone,2 |
      | INSERTED_BY    | closePayment-v2                                                                             |
      | UPDATED_BY     | closePayment-v2                                                                             |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value PPAL in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.pspTransactionId json check value NotNone in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.transactionId json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.paypalPayment.transactionId xml check value NotNone in position 0
    And from $pspNotifyPaymentReq.paypalPayment.pspTransactionId xml check value NotNone in position 0
    And from $pspNotifyPaymentReq.paypalPayment.totalAmount xml check value 12 in position 0
    And from $pspNotifyPaymentReq.paypalPayment.fee xml check value 2 in position 0
    And from $pspNotifyPaymentReq.paypalPayment.timestampOperation xml check value 2021-07-09T17:06:03 in position 0
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcome REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
    And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeReq.idChannel xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
    And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
    # sendPaymentOutcome RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
    And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0





  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_4 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1 e Travaso BPAY, FLOW: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPayment con bancomatpayPayment, spo+ -> paInviaRT+, BIZ+ e SPRv2+ (NMU-11)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_BPAY initial json v2/closepayment
      | token1                | $activatePaymentNoticeV2Response.paymentToken |
      | outcome               | OK                                            |
      | idPSP                 | #psp#                                         |
      | idBrokerPSP           | #id_broker_psp#                               |
      | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | paymentMethod         | BPAY                                          |
      | transactionId         | #transaction_id#                              |
      | totalAmountExt        | 12                                            |
      | feeExt                | 2                                             |
      | primaryCiIncurredFee  | 1                                             |
      | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
      | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
      | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
      | transId               | #transaction_id#                              |
      | outPaymentGateway     | 00                                            |
      | totalAmount1          | 12                                            |
      | fee1                  | 2                                             |
      | timestampOperation1   | 2021-07-09T17:06:03                           |
      | authorizationCode     | 123456                                        |
      | paymentGateway        | 00                                            |
    And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2                                             |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcome                  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                                         |
      | TRANSACTION_ID | $transaction_id                                                                                                               |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,authorizationCode,timestampOperation,totalAmount,paymentGateway,transactionId,fee |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,BPAY,00,123456,2021-07-09T17:06:03,12,00,NotNone,2                              |
      | INSERTED_BY    | closePayment-v2                                                                                                               |
      | UPDATED_BY     | closePayment-v2                                                                                                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value BPAY in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.transactionId json check value NotNone in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.transactionId xml check value NotNone in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.outcomePaymentGateway xml check value 00 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.totalAmount xml check value 12 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.fee xml check value 2 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.timestampOperation xml check value 2021-07-09T17:06:03 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.authorizationCode xml check value 123456 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.paymentGateway xml check value 00 in position 0
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcome REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
    And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeReq.idChannel xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
    And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
    # sendPaymentOutcome RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
    And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0





  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_5 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1 notify PSP vp2 spo: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPayment con additionalPaymentInformations, spoV2+ -> paInviaRT+, BIZ+ e SPRv2+ (NMU-12)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
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
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
      | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcomeV2                |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,2021-07-09T17:06:03,12,00,2,123456,NotNone                      |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.transactionId json check value NotNone in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
    And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_versione_primitive_2# in position 0
    And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
    And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
    And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_6 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1 notify PSP vp2 spo e Travaso CP, FLOW: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPayment con creditCardPayment, spoV2+ -> paInviaRT+, BIZ+ e SPRv2+ (NMU-13)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
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
    And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
      | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2                                             |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcomeV2                |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,2021-07-09T17:06:03,12,00,2,123456,11223344                     |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.transactionId json check value NotNone in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.creditCardPayment.rrn xml check value 11223344 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.outcomePaymentGateway xml check value 00 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.totalAmount xml check value 12 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.fee xml check value 2 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.timestampOperation xml check value 2021-07-09T17:06:03 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.authorizationCode xml check value 123456 in position 0
    And from $pspNotifyPaymentReq.creditCardPayment.paymentGateway xml check value 00 in position 0
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
    And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_versione_primitive_2# in position 0
    And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
    And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
    And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_7 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1 notify PSP vp2 spo e Travaso PPAL, FLOW: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPayment con paypalPayment, spoV2+ -> paInviaRT+, BIZ+ e SPRv2+ (NMU-14)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_PPAL initial json v2/closepayment
      | token1                | $activatePaymentNoticeV2Response.paymentToken |
      | outcome               | OK                                            |
      | idPSP                 | #psp#                                         |
      | idBrokerPSP           | #id_broker_psp#                               |
      | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | paymentMethod         | PPAL                                          |
      | transactionId         | #transaction_id#                              |
      | totalAmountExt        | 12                                            |
      | feeExt                | 2                                             |
      | primaryCiIncurredFee  | 1                                             |
      | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
      | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
      | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
      | transId               | #transaction_id#                              |
      | pspTransactionId      | #psp_transaction_id#                          |
      | totalAmount1          | 12                                            |
      | fee1                  | 2                                             |
      | timestampOperation1   | 2021-07-09T17:06:03                           |
    And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
      | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcomeV2                |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                           |
      | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id |
      | KEY            | Token,Tipo versamento,pspTransactionId,timestampOperation,totalAmount,transactionId,fee                         |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,PPAL,NotNone,2021-07-09T17:06:03,12,NotNone,2                     |
      | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2 |
      | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value PPAL in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.transactionId json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.pspTransactionId json check value NotNone in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.paypalPayment.transactionId xml check value NotNone in position 0
    And from $pspNotifyPaymentReq.paypalPayment.pspTransactionId xml check value NotNone in position 0
    And from $pspNotifyPaymentReq.paypalPayment.totalAmount xml check value 12 in position 0
    And from $pspNotifyPaymentReq.paypalPayment.fee xml check value 2 in position 0
    And from $pspNotifyPaymentReq.paypalPayment.timestampOperation xml check value 2021-07-09T17:06:03 in position 0
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
    And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_versione_primitive_2# in position 0
    And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
    And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
    And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0



  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_8 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1 notify PSP vp2 spo e Travaso BPAY, FLOW: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPayment con bancomatpayPayment, spoV2+ -> paInviaRT+, BIZ+ e SPRv2+ (NMU-15)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_BPAY initial json v2/closepayment
      | token1                | $activatePaymentNoticeV2Response.paymentToken |
      | outcome               | OK                                            |
      | idPSP                 | #psp#                                         |
      | idBrokerPSP           | #id_broker_psp#                               |
      | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | paymentMethod         | BPAY                                          |
      | transactionId         | #transaction_id#                              |
      | totalAmountExt        | 12                                            |
      | feeExt                | 2                                             |
      | primaryCiIncurredFee  | 1                                             |
      | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
      | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
      | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
      | transId               | #transaction_id#                              |
      | outPaymentGateway     | 00                                            |
      | totalAmount1          | 12                                            |
      | fee1                  | 2                                             |
      | timestampOperation1   | 2021-07-09T17:06:03                           |
      | authorizationCode     | 123456                                        |
      | paymentGateway        | 00                                            |
    And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
      | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcomeV2                |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                                         |
      | TRANSACTION_ID | $transaction_id                                                                                                               |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,authorizationCode,timestampOperation,totalAmount,paymentGateway,transactionId,fee |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,BPAY,00,123456,2021-07-09T17:06:03,12,00,NotNone,2                              |
      | INSERTED_BY    | closePayment-v2                                                                                                               |
      | UPDATED_BY     | closePayment-v2                                                                                                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value BPAY in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.transactionId json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.transactionId xml check value NotNone in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.outcomePaymentGateway xml check value 00 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.totalAmount xml check value 12 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.fee xml check value 2 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.timestampOperation xml check value 2021-07-09T17:06:03 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.authorizationCode xml check value 123456 in position 0
    And from $pspNotifyPaymentReq.ctBancomatpayPayment.paymentGateway xml check value 00 in position 0
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
    And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_versione_primitive_2# in position 0
    And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
    And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
    And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0





  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_9 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp2 notify PSP vp1 spo, FLOW: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPaymentV2 con additionalPaymentInformations, spo+ -> paInviaRT+, BIZ+ e SPRv2+ (NMU-16)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
      | token1                | $activatePaymentNoticeV2Response.paymentToken |
      | outcome               | OK                                            |
      | idPSP                 | #psp#                                         |
      | idBrokerPSP           | #id_broker_psp#                               |
      | idChannel             | #canale_versione_primitive_2#                 |
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
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_versione_primitive_2#                 |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2                                             |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcome                  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,2021-07-09T17:06:03,12,00,2,123456,NotNone                      |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.transactionId json check value NotNone in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPaymentV2                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Req
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
    # pspNotifyPaymentV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPaymentV2                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Resp
    And from $pspNotifyPaymentV2Resp.outcome xml check value OK in position 0
    # sendPaymentOutcome REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
    And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeReq.idChannel xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
    And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
    # sendPaymentOutcome RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
    And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_10 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp2: checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspnotifyV2, spoV2+  -> paaInviaRT+, BIZ+ e SPRv2+ (NMU-20)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
      | token1                | $activatePaymentNoticeV2Response.paymentToken |
      | outcome               | OK                                            |
      | idPSP                 | #psp#                                         |
      | idBrokerPSP           | #id_broker_psp#                               |
      | idChannel             | #canale_versione_primitive_2#                 |
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
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
      | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_versione_primitive_2#                 |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcomeV2                |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,2021-07-09T17:06:03,12,00,2,123456,NotNone                      |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPaymentV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPaymentV2                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Req
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
    # pspNotifyPaymentV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPaymentV2                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Resp
    And from $pspNotifyPaymentV2Resp.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
    And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_versione_primitive_2# in position 0
    And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
    And from $sendPaymentOutcomeV2Req.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
    And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_11 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1, chiamate parallelo -> spo+ arriva prima della risposta alla notify -> checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPayment con additionalPaymentInformations REQ, spo+ REQ -> attesa lock, pspNotify RESP OK, spo+ RESP OK -> paInviaRT+, BIZ+ (NMU-21)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
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
    Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    Then saving v2/closepayment request in v2/closepayment
    And saving sendPaymentOutcome request in sendPaymentOutcome
    Given from body with datatable horizontal pspNotifyPayment_OK_delay_noOptional initial XML pspNotifyPayment
      | outcome | delay |
      | OK      | 2000  |
    And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
    When calling primitive evolution v2/closepayment and sendPaymentOutcome with POST and POST in parallel with 1000 ms delay
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    And check outcome is OK of sendPaymentOutcome response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcome                  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,NotNone,12,00,2,123456,11223344                                 |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # RE CRONOLOGIA EVENTI REQ E RESP
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column            | value                                                                                                                                                                                                                                       |
      | tipo_evento       | activatePaymentNoticeV2,paaAttivaRPT,paaAttivaRPT,activatePaymentNoticeV2,nodoInviaRPT,nodoInviaRPT,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcome,pspNotifyPayment,sendPaymentOutcome,NotNone,NotNone,NotNone,NotNone |
      | sotto_tipo_evento | REQ,REQ,RESP,RESP,REQ,RESP,REQ,RESP,REQ,REQ,RESP,RESP,NotNone,NotNone,NotNone,NotNone                                                                                                                                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | SOTTO_TIPO_EVENTO  | ('REQ','RESP')                                |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcome REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
    And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeReq.idChannel xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
    And from $sendPaymentOutcomeReq.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
    # sendPaymentOutcome RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
    And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_12 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp2, chiamate parallelo -> spo+ arriva prima della risposta alla notify -> checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPaymentV2 REQ, spoV2+ REQ -> attesa lock, pspNotifyV2 RESP OK, spoV2+ RESP OK -> paInviaRT+, BIZ+ (NMU-22)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
      | token1                | $activatePaymentNoticeV2Response.paymentToken |
      | outcome               | OK                                            |
      | idPSP                 | #psp#                                         |
      | idBrokerPSP           | #id_broker_psp#                               |
      | idChannel             | #canale_versione_primitive_2#                 |
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
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
      | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    Then saving v2/closepayment request in v2/closepayment
    And saving sendPaymentOutcomeV2 request in sendPaymentOutcomeV2
    Given from body with datatable horizontal pspNotifyPaymentV2_OK_delay_noOptional initial XML pspNotifyPaymentV2
      | outcome | delay |
      | OK      | 2000  |
    And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2
    When calling primitive evolution v2/closepayment and sendPaymentOutcomeV2 with POST and POST in parallel with 1000 ms delay
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    And check outcome is OK of sendPaymentOutcomeV2 response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_versione_primitive_2#                 |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcomeV2                |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,NotNone,12,00,2,123456,11223344                                 |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # RE CRONOLOGIA EVENTI REQ E RESP
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column            | value                                                                                                                                                                                                                                               |
      | tipo_evento       | activatePaymentNoticeV2,paaAttivaRPT,paaAttivaRPT,activatePaymentNoticeV2,nodoInviaRPT,nodoInviaRPT,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,pspNotifyPaymentV2,sendPaymentOutcomeV2,NotNone,NotNone,NotNone,NotNone |
      | sotto_tipo_evento | REQ,REQ,RESP,RESP,REQ,RESP,REQ,RESP,REQ,REQ,RESP,RESP,NotNone,NotNone,NotNone,NotNone                                                                                                                                                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | SOTTO_TIPO_EVENTO  | ('REQ','RESP')                                |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPaymentV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPaymentV2                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Req
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
    # pspNotifyPaymentV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPaymentV2                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Resp
    And from $pspNotifyPaymentV2Resp.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
    And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_versione_primitive_2# in position 0
    And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
    And from $sendPaymentOutcomeV2Req.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
    And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_13 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1 notify e PSP vp2 spo, chiamate parallelo -> spo+ arriva prima della risposta alla notify -> checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPayment con additionalPaymentInformations REQ, spoV2+ REQ -> attesa lock, pspNotify RESP OK, spoV2+ RESP OK -> paInviaRT+, BIZ+ (NMU-23)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
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
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
      | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    Then saving v2/closepayment request in v2/closepayment
    And saving sendPaymentOutcomeV2 request in sendPaymentOutcomeV2
    Given from body with datatable horizontal pspNotifyPayment_OK_delay_noOptional initial XML pspNotifyPayment
      | outcome | delay |
      | OK      | 2000  |
    And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
    When calling primitive evolution v2/closepayment and sendPaymentOutcomeV2 with POST and POST in parallel with 1000 ms delay
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    And check outcome is OK of sendPaymentOutcomeV2 response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcomeV2                |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,NotNone,12,00,2,123456,11223344                                 |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # RE CRONOLOGIA EVENTI REQ E RESP
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column            | value                                                                                                                                                                                                                                           |
      | tipo_evento       | activatePaymentNoticeV2,paaAttivaRPT,paaAttivaRPT,activatePaymentNoticeV2,nodoInviaRPT,nodoInviaRPT,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcomeV2,pspNotifyPayment,sendPaymentOutcomeV2,NotNone,NotNone,NotNone,NotNone |
      | sotto_tipo_evento | REQ,REQ,RESP,RESP,REQ,RESP,REQ,RESP,REQ,REQ,RESP,RESP,NotNone,NotNone,NotNone,NotNone                                                                                                                                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | SOTTO_TIPO_EVENTO  | ('REQ','RESP')                                |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
    And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
    And from $sendPaymentOutcomeV2Req.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
    # sendPaymentOutcomeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
    And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_14 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp2 notify e PSP vp1 spo, chiamate parallelo -> spo+ arriva prima della risposta alla notify -> checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT, closeV2+ -> pspNotifyPaymentV2 con additionalPaymentInformations REQ, spo+ REQ -> attesa lock, pspNotifyV2 RESP OK, spo+ RESP OK -> paInviaRT+, BIZ+ (NMU-24)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
      | token1                | $activatePaymentNoticeV2Response.paymentToken |
      | outcome               | OK                                            |
      | idPSP                 | #psp#                                         |
      | idBrokerPSP           | #id_broker_psp#                               |
      | idChannel             | #canale_versione_primitive_2#                 |
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
    Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    Then saving v2/closepayment request in v2/closepayment
    And saving sendPaymentOutcome request in sendPaymentOutcome
    Given from body with datatable horizontal pspNotifyPaymentV2_OK_delay_noOptional initial XML pspNotifyPaymentV2
      | outcome | delay |
      | OK      | 2000  |
    And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2
    When calling primitive evolution v2/closepayment and sendPaymentOutcome with POST and POST in parallel with 1000 ms delay
    Then verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    And check outcome is OK of sendPaymentOutcome response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_versione_primitive_2#                 |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcome                  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,NotNone,12,00,2,123456,11223344                                 |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # RE CRONOLOGIA EVENTI REQ E RESP
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column            | value                                                                                                                                                                                                                                           |
      | tipo_evento       | activatePaymentNoticeV2,paaAttivaRPT,paaAttivaRPT,activatePaymentNoticeV2,nodoInviaRPT,nodoInviaRPT,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcome,pspNotifyPaymentV2,sendPaymentOutcome,NotNone,NotNone,NotNone,NotNone |
      | sotto_tipo_evento | REQ,REQ,RESP,RESP,REQ,RESP,REQ,RESP,REQ,REQ,RESP,RESP,NotNone,NotNone,NotNone,NotNone                                                                                                                                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | SOTTO_TIPO_EVENTO  | ('REQ','RESP')                                |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value NotNone in position 1
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPaymentV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPaymentV2                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Req
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
    And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
    # pspNotifyPaymentV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPaymentV2                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Resp
    And from $pspNotifyPaymentV2Resp.outcome xml check value OK in position 0
    # sendPaymentOutcome REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
    And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeReq.idChannel xml check value #canale_versione_primitive_2# in position 0
    And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
    And from $sendPaymentOutcomeReq.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
    # sendPaymentOutcome RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
    And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0


  @ALL @FLOW @FLOW_FULL @NMU @NMUPAOLD @NMUPAOLDPAGOK @NMUPAOLDPAGOK_FULL_15 @after
  Scenario: NMU flow OK, FLOW con PA Old e PSP vp1, chiamate parallelo -> CloseV2 prima di response a RPT -> checkPosition con 1 nav, activateV2 -> paaAttivaRPT, nodoInviaRPT REQ, closeV2+ REQ -> non c'è il lock, prosegue solo se è già stata scritta la RPT a DB, nodoInviaRPT RESP, closeV2 RESP -> pspNotify con additionalPaymentInformations, spo+ -> paInviaRT+, BIZ+ e SPR+ (NMU-4)
    Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal checkPositionBody initial JSON checkPosition
      | fiscalCode                  | noticeNumber |
      | #creditor_institution_code# | 312#iuv#     |
    When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
    Then verify the HTTP status code of checkPosition response is 200
    And check outcome is OK of checkPosition response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
      | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
    And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
      | esito | importoSingoloVersamento |
      | OK    | 10.00                    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
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
    Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
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
    Then saving nodoInviaRPT request in nodoInviaRPT
    And saving v2/closepayment request in v2/closepayment
    When calling primitive evolution nodoInviaRPT and v2/closepayment with POST and POST in parallel with 300 ms delay
    Then check esito is OK of nodoInviaRPT response
    And verify the HTTP status code of v2/closepayment response is 200
    And check outcome is OK of v2/closepayment response
    Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
      | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And wait 1 seconds for expiration
    # RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column           | value                                        |
      | CANALE           | $nodoInviaRPT.identificativoCanale           |
      | PSP              | $nodoInviaRPT.identificativoPSP              |
      | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
      | TIPO_VERSAMENTO  | PO                                           |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PSP_ID                | #psp#                                         |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                       |
      | TOKEN_VALID_TO        | NotNone                                       |
      | DUE_DATE              | None                                          |
      | AMOUNT                | $activatePaymentNoticeV2.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
      | INSERTED_BY           | activatePaymentNoticeV2                       |
      | UPDATED_BY            | closePayment-v2                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                   |
      | ID                 | NotNone                 |
      | DESCRIPTION        | NotNone                 |
      | COMPANY_NAME       | NotNone                 |
      | OFFICE_NAME        | None                    |
      | DEBTOR_ID          | NotNone                 |
      | INSERTED_TIMESTAMP | NotNone                 |
      | UPDATED_TIMESTAMP  | NotNone                 |
      | INSERTED_BY        | activatePaymentNoticeV2 |
      | UPDATED_BY         | activatePaymentNoticeV2 |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                           |
      | ID                    | NotNone                         |
      | CREDITOR_REFERENCE_ID | 12$iuv                          |
      | DUE_DATE              | NotNone                         |
      | RETENTION_DATE        | None                            |
      | AMOUNT                | $activatePaymentNoticeV2.amount |
      | FLAG_FINAL_PAYMENT    | Y                               |
      | INSERTED_TIMESTAMP    | NotNone                         |
      | UPDATED_TIMESTAMP     | NotNone                         |
      | METADATA              | None                            |
      | FK_POSITION_SERVICE   | NotNone                         |
      | INSERTED_BY           | activatePaymentNoticeV2         |
      | UPDATED_BY            | activatePaymentNoticeV2         |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                         |
      | ID                         | NotNone                                       |
      | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
      | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
      | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio           |
      | STATION_ID                 | #id_station_old#                              |
      | STATION_VERSION            | 1                                             |
      | PSP_ID                     | #psp#                                         |
      | BROKER_PSP_ID              | #id_broker_psp#                               |
      | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
      | AMOUNT                     | $activatePaymentNoticeV2.amount               |
      | FEE                        | 2.00                                          |
      | OUTCOME                    | NotNone                                       |
      | PAYMENT_METHOD             | None                                          |
      | PAYMENT_CHANNEL            | NA                                            |
      | TRANSFER_DATE              | None                                          |
      | PAYER_ID                   | None                                          |
      | INSERTED_TIMESTAMP         | NotNone                                       |
      | UPDATED_TIMESTAMP          | NotNone                                       |
      | FK_PAYMENT_PLAN            | NotNone                                       |
      | RPT_ID                     | NotNone                                       |
      | PAYMENT_TYPE               | MOD3                                          |
      | CARRELLO_ID                | None                                          |
      | ORIGINAL_PAYMENT_TOKEN     | None                                          |
      | FLAG_IO                    | N                                             |
      | RICEVUTA_PM                | Y                                             |
      | FLAG_PAYPAL                | N                                             |
      | FLAG_ACTIVATE_RESP_MISSING | None                                          |
      | TRANSACTION_ID             | $transaction_id                               |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | CREDITOR_REFERENCE_ID    | 12$iuv                              |
      | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNoticeV2.amount     |
      | REMITTANCE_INFORMATION   | NotNone                             |
      | TRANSFER_CATEGORY        | NotNone                             |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNoticeV2             |
      | UPDATED_BY               | sendPaymentOutcome                  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                                |
      | ID                    | NotNone                                                                                              |
      | CREDITOR_REFERENCE_ID | 12$iuv                                                                                               |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                        |
      | STATUS                | PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED |
      | INSERTED_TIMESTAMP    | NotNone                                                                                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                         |
      | ID                    | NotNone                                       |
      | FK_POSITION_PAYMENT   | NotNone                                       |
      | CREDITOR_REFERENCE_ID | 12$iuv                                        |
      | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
      | STATUS                | NOTICE_STORED                                 |
      | INSERTED_TIMESTAMP    | NotNone                                       |
      | UPDATED_TIMESTAMP     | NotNone                                       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                     |
      | ID                 | NotNone                   |
      | STATUS             | PAYING,PAID,NOTICE_STORED |
      | INSERTED_TIMESTAMP | NotNone                   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value         |
      | ID                  | NotNone       |
      | STATUS              | NOTICE_STORED |
      | INSERTED_TIMESTAMP  | NotNone       |
      | UPDATED_TIMESTAMP   | NotNone       |
      | FK_POSITION_SERVICE | NotNone       |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                          |
      | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
      | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                          |
      | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
    # PM_SESSION_DATA
    And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys  | where_values                                  |
      | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
    # PM_METADATA
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column         | value                                                                                                               |
      | TRANSACTION_ID | $transaction_id                                                                                                     |
      | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
      | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,NotNone,12,00,2,123456,11223344                                 |
      | INSERTED_BY    | closePayment-v2                                                                                                     |
      | UPDATED_BY     | closePayment-v2                                                                                                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values    |
      | TRANSACTION_ID | $transaction_id |
      | ORDER BY       | ID ASC          |
    # STATI_RPT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value                                                                                                                                      |
      | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
    And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # STATI_RPT_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value           |
      | STATO  | RT_ACCETTATA_PA |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
      | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
    And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                                  |
      | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
    # RE #####
    # activatePaymentNoticeV2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
    And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
    And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
    And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
    And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
    # activatePaymentNoticeV2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | activatePaymentNoticeV2                       |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
    And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
    And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.paymentDescription xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
    And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 12$iuv in position 0
    # paaAttivaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
    And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaAttivaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canale_AGID_02# in position 0
    # paaAttivaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaAttivaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
    And from $paaAttivaRPTResp.esito xml check value OK in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
    And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
    # nodoInviaRPT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
    And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $nodoInviaRPTReq.password xml check value #password# in position 0
    And from $nodoInviaRPTReq.identificativoPSP xml check value #psp_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #broker_AGID# in position 0
    And from $nodoInviaRPTReq.identificativoCanale xml check value #canale_AGID_02# in position 0
    And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
    # nodoInviaRPT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | nodoInviaRPT                                  |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
    And from $nodoInviaRPTResp.esito xml check value OK in position 0
    And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
    # closePayment-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
    And from $closePaymentv2Req.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
    And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $closePaymentv2Req.idPSP json check value #psp# in position 0
    And from $closePaymentv2Req.outcome json check value OK in position 0
    And from $closePaymentv2Req.paymentMethod json check value CP in position 0
    And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2023-11-30T12:46:46.554+01:00 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
    And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
    # closePayment-v2 RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | closePayment-v2                               |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
    And from $closePaymentv2Resp.outcome json check value OK in position 0
    # pspNotifyPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
    And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
    # pspNotifyPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | pspNotifyPayment                              |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
    And from $pspNotifyPaymentResp.outcome xml check value OK in position 0
    # sendPaymentOutcome REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
    And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
    And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
    And from $sendPaymentOutcomeReq.idChannel xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
    And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
    And from $sendPaymentOutcomeReq.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
    # sendPaymentOutcome RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentOutcome                            |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
    And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
    # paaInviaRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
    And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
    And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
    And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
    And from $paaInviaRTReq.rt xml check value NotNone in position 0
    # paaInviaRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | paaInviaRT                                    |
      | SOTTO_TIPO_EVENTO  | RESP                                          |
      | ESITO              | RICEVUTA                                      |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
    And from $paaInviaRTResp.esito xml check value OK in position 0
    # sendPaymentResult-v2 REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                  |
      | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
      | TIPO_EVENTO        | sendPaymentResult-v2                          |
      | SOTTO_TIPO_EVENTO  | REQ                                           |
      | ESITO              | INVIATA                                       |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
      | ORDER BY           | DATA_ORA_EVENTO ASC                           |
    And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
    And from $sendPaymentResultv2Req.outcome json check value OK in position 0
    And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
    And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 12$iuv in position 0
    And from $sendPaymentResultv2Req.payments.debtor json check value RCCGLD09P09H501E in position 0
    And from $sendPaymentResultv2Req.payments.description json check value pagamento multibeneficiario in position 0
    And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
    And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0