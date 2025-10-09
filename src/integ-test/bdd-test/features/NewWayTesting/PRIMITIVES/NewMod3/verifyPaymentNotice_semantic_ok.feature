Feature: Semantic checks for verifyPaymentReq - OK 1401

   Background:
      Given systems up


   @ALL @PRIMITIVE @NM3 @NM3VPNSEMOK @NM3VPNSEMOK_1
   Scenario: Check valid URL in WSDL namespace
      Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
         | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
         | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
      When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response

