Feature: Syntax checks for verificaBollettino - OK 1399

   Background:
      Given systems up


   @ALL @PRIMITIVE @NM3 @NM3VBLSNTKO @NM3VBLSNTKO_1
   Scenario: SIN_VB_00
      Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
         | idPSP  | idBrokerPSP | idChannel | password   | ccPost    | noticeNumber |
         | POSTE3 | BANCOPOSTA  | POSTE3    | #password# | #ccPoste# | 302#iuv#     |
      When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
      Then check outcome is OK of verificaBollettino response



