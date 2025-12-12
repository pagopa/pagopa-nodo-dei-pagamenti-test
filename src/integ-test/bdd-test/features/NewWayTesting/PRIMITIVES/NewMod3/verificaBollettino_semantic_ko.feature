Feature: Semantic checks for verificaBollettino - KO 1394

  Background:
    Given systems up


  @ALL @PRIMITIVE @NM3 @NM3VBLSEMKO @NM3VBLSEMKO_1
  Scenario Outline: Semantic checks for verificaBollettino
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP  | idBrokerPSP | idChannel | password   | ccPost    | noticeNumber |
      | POSTE3 | BANCOPOSTA  | POSTE3    | #password# | #ccPoste# | 302#iuv#     |
    And <elem> with <value> in verificaBollettino
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is <faultCode> of verificaBollettino response
    And check description is <description> of verificaBollettino response
    Examples:
      | elem        | value              | faultCode                          | description                                          | soapUI test |
      | idPSP       | pspUnknown         | PPT_PSP_SCONOSCIUTO                | PSP sconosciuto.                                     | SEM_VB_01   |
      | idPSP       | NOT_ENABLED        | PPT_PSP_DISABILITATO               | PSP conosciuto ma disabilitato da configurazione.    | SEM_VB_02   |
      | idBrokerPSP | brokerPspUnknown   | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  | Identificativo intermediario psp sconosciuto.        | SEM_VB_03   |
      | idBrokerPSP | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO | Intermediario psp disabilitato.                      | SEM_VB_04   |
      | idBrokerPSP | 91000000001        | PPT_AUTORIZZAZIONE                 | Configurazione intermediario-canale non corretta     | SEM_VB_12   |
      | idChannel   | channelUnknown     | PPT_CANALE_SCONOSCIUTO             | Canale sconosciuto.                                  | SEM_VB_05   |
      | idChannel   | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO            | Canale conosciuto ma disabilitato da configurazione. | SEM_VB_06   |
      | ccPost      | 777777777772       | PPT_SEMANTICA                      | Codifica non riconosciuta                            | SEM_VB_09   |


  @ALL @PRIMITIVE @NM3 @NM3VBLSEMKO @NM3VBLSEMKO_2
  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_VB_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP  | idBrokerPSP | idChannel | password   | ccPost    | noticeNumber |
      | POSTE3 | BANCOPOSTA  | POSTE3    | #password# | #ccPoste# | 302#iuv#     |
    And idChannel with POSTE1_ONUS in verificaBollettino
    And idPSP with POSTE1 in verificaBollettino
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_AUTORIZZAZIONE of verificaBollettino response
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP' of verificaBollettino response


  @ALL @PRIMITIVE @NM3 @NM3VBLSEMKO @NM3VBLSEMKO_3
  # password value check: wrong password for an idChannel [SEM_VB_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP  | idBrokerPSP | idChannel | password   | ccPost    | noticeNumber |
      | POSTE3 | BANCOPOSTA  | POSTE3    | #password# | #ccPoste# | 302#iuv#     |
    And idChannel with POSTE3 in verificaBollettino
    And password with password in verificaBollettino
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_AUTENTICAZIONE of verificaBollettino response


  @ALL @PRIMITIVE @NM3 @NM3VBLSEMKO @NM3VBLSEMKO_4
  # station value check: noticeNumber with unknonw progressivo [SEM_VB_11]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP  | idBrokerPSP | idChannel | password   | ccPost    | noticeNumber |
      | POSTE3 | BANCOPOSTA  | POSTE3    | #password# | #ccPoste# | 302#iuv#     |
    And ccPost with 777777777777 in verificaBollettino
    And noticeNumber with 713014851147176400 in verificaBollettino
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of verificaBollettino response



  @ALL @PRIMITIVE @NM3 @NM3VBLSEMKO @NM3VBLSEMKO_5
  # station value check: combination ccPost-noticeNumber identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_VB_14]
  Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP  | idBrokerPSP | idChannel | password   | ccPost    | noticeNumber |
      | POSTE3 | BANCOPOSTA  | POSTE3    | #password# | #ccPoste# | 302#iuv#     |
    And ccPost with 777777777777 in verificaBollettino
    And noticeNumber with 313019441991132400 in verificaBollettino
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of verificaBollettino response