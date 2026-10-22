Feature: syntax checks for paVerifyPaymentNoticeRes - OK 1346

  Background:
    Given systems up


  @ALL @PRIMITIVE @NM3 @NM3VBLPVNRSNTOK @NM3VBLPVNRSNTOK_1
  Scenario Outline: Check paVerifyPayment response with missing optional fields
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
    And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
    Examples:
      | elem              | value | soapUI test |
      | soapenv:Header    | None  | SIN_VBR_01  |
      | dueDate           | None  | SIN_VBR_25  |
      | detailDescription | None  | SIN_VBR_28  |
      | officeName        | None  | SIN_VBR_44  |