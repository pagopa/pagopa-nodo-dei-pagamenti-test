Feature: syntax checks for paVerifyPaymentNoticeRes - OK 1388

   Background:
      Given systems up


   @ALL @PRIMITIVE @NM3 @NM3PAVNRSSNTOK @NM3PAVNRSSNTOK_1
   Scenario Outline: Check paVerifyPaymentRes response with missing optional fields
      Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
         | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
         | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
      And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
         | outcome            | OK             |
         | amount             | 10.00          |
         | options            | EQ             |
         | dueDate            | 2021-12-31     |
         | allCCP             | 1              |
         | paymentDescription | test           |
         | fiscalCodePA       | #fiscalCodePA# |
         | companyName        | company        |
         | officeName         | office         |
      And <elem> with <value> in paVerifyPaymentNotice
      And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
      When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response
      Examples:
         | elem              | value | soapUI test  |
         | soapenv:Header    | None  | SIN_PVPNR_01 |
         | dueDate           | None  | SIN_PVPNR_25 |
         | detailDescription | None  | SIN_PVPNR_28 |
         | officeName        | None  | SIN_PVPNR_44 |
