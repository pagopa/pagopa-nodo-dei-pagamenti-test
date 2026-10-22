Feature: syntax checks for paVerifyPaymentNotice - KO 1345

  Background:
    Given systems up


  @ALL @PRIMITIVE @NM3 @NM3VBLPVNRSNTKO @NM3VBLPVNRSNTKO_1
  # element value check
  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 302#iuv#     |
    And from body with datatable vertical paVerifyPaymentNotice_KO initial XML paVerifyPaymentNotice
      | faultCode   | PAA_SEMANTICA               |
      | faultString | chiamata da rifiutare       |
      | id          | #creditor_institution_code# |
      | outcome     | KO                          |
      | description | haloo                       |
    And <elem> with <value> in paVerifyPaymentNotice
    And if outcome is KO set fault to None in paVerifyPaymentNotice
    And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of verificaBollettino response
    Examples:
      | elem                         | value | soapUI test |
      | soapenv:Body                 | None  | SIN_VBR_02  |
      | soapenv:Body                 | Empty | SIN_VBR_03  |
      | paf:paVerifyPaymentNoticeRes | None  | SIN_VBR_04  |
      | paf:paVerifyPaymentNoticeRes | Empty | SIN_VBR_06  |
      | outcome                      | None  | SIN_VBR_07  |
      | outcome                      | Empty | SIN_VBR_08  |
      | outcome                      | PP    | SIN_VBR_09  |
      | outcome                      | KO    | SIN_VBR_10  |


  @ALL @PRIMITIVE @NM3 @NM3VBLPVNRSNTKO @NM3VBLPVNRSNTKO_2
  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 302#iuv#     |
    And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
      | outcome            | OK             |
      | amount             | 10.00          |
      | options            | EQ             |
      | allCCP             | 1              |
      | paymentDescription | test           |
      | fiscalCodePA       | #fiscalCodePA# |
      | companyName        | test           |
    And <elem> with <value> in paVerifyPaymentNotice
    And if outcome is KO set fault to None in paVerifyPaymentNotice
    And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of verificaBollettino response
    Examples:
      | elem                     | value                                                                                                                                           | soapUI test |
      | paymentList              | None                                                                                                                                            | SIN_VBR_11  |
      | paymentList              | Empty                                                                                                                                           | SIN_VBR_13  |
      | paymentOptionDescription | None                                                                                                                                            | SIN_VBR_14  |
      | paymentOptionDescription | Empty                                                                                                                                           | SIN_VBR_15  |
      | paymentOptionDescription | Occurrences,2                                                                                                                                   | SIN_VBR_16  |
      | amount                   | None                                                                                                                                            | SIN_VBR_17  |
      | amount                   | Empty                                                                                                                                           | SIN_VBR_18  |
      | amount                   | 11,34                                                                                                                                           | SIN_VBR_19  |
      | amount                   | 11.342                                                                                                                                          | SIN_VBR_20  |
      | amount                   | 11.3                                                                                                                                            | SIN_VBR_20  |
      | amount                   | 1219087657.34                                                                                                                                   | SIN_VBR_21  |
      | options                  | None                                                                                                                                            | SIN_VBR_22  |
      | options                  | Empty                                                                                                                                           | SIN_VBR_23  |
      | options                  | KK                                                                                                                                              | SIN_VBR_24  |
      | dueDate                  | Empty                                                                                                                                           | SIN_VBR_26  |
      | dueDate                  | 12-28-2022                                                                                                                                      | SIN_VBR_27  |
      | dueDate                  | 12-09-22                                                                                                                                        | SIN_VBR_27  |
      | dueDate                  | 12-08-2022T12:00:678                                                                                                                            | SIN_VBR_27  |
      | detailDescription        | Empty                                                                                                                                           | SIN_VBR_29  |
      | detailDescription        | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_VBR_30  |
      | allCCP                   | None                                                                                                                                            | SIN_VBR_31  |
      | allCCP                   | Empty                                                                                                                                           | SIN_VBR_32  |
      | allCCP                   | 3                                                                                                                                               | SIN_VBR_33  |
      | paymentDescription       | None                                                                                                                                            | SIN_VBR_34  |
      | paymentDescription       | Empty                                                                                                                                           | SIN_VBR_35  |
      | paymentDescription       | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_VBR_36  |
      | fiscalCodePA             | None                                                                                                                                            | SIN_VBR_37  |
      | fiscalCodePA             | Empty                                                                                                                                           | SIN_VBR_38  |
      | fiscalCodePA             | 123456789012                                                                                                                                    | SIN_VBR_39  |
      | fiscalCodePA             | 12345jh%lk9                                                                                                                                     | SIN_VBR_40  |
      | companyName              | None                                                                                                                                            | SIN_VBR_41  |
      | companyName              | Empty                                                                                                                                           | SIN_VBR_42  |
      | companyName              | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_VBR_43  |
      | officeName               | Empty                                                                                                                                           | SIN_VBR_45  |
      | officeName               | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_VBR_46  |

