Feature: Semantic checks for verificaBollettino - OK 1395

  Background:
    Given systems up

  @ALL @PRIMITIVE @NM3 @NM3VBLSEMOK @NM3VBLSEMOK_3
  Scenario: Check valid URL in WSDL namespace
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP | idBrokerPSP | idChannel                    | password   | ccPost    | noticeNumber |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #ccPoste# | 302#iuv#     |
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response


  @ALL @PRIMITIVE @NM3 @NM3VBLSEMOK @NM3VBLSEMOK_4
  #[SEM_VB_13] pt.1
  Scenario Outline: Execute verificaBollettino request
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP | idBrokerPSP | idChannel                    | password   | ccPost    | noticeNumber |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #ccPoste# | 302#iuv#     |
    And <elem> with <value> in verificaBollettino
    When psp sends soap verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of verificaBollettino response
    Examples:
      | elem  | value                                | soapUI test |
      | idPSP | 123456789012345678901234567890123456 | SEM_VB_13   |


  @ALL @PRIMITIVE @NM3 @NM3VBLSEMOK @NM3VBLSEMOK_5
  #[SEM_VB_13] pt.2
  Scenario: Excecute verificaBollettino2 request
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP | idBrokerPSP | idChannel                    | password   | ccPost    | noticeNumber |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #ccPoste# | 302#iuv#     |
    And ccPost with 666666666666 in verificaBollettino
    When psp sends soap verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
