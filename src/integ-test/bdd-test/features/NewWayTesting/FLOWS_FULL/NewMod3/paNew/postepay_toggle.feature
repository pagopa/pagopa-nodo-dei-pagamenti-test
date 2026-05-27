

Feature: PostePay Toggle Configuration Tests
Background:
 Given systems up
@ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @POSTEPAY @POSTEPAY_TOGGLE @POSTEPAY_TOGGLE_01
  Scenario: POSTEPAY_TOGGLE_01 PostePay Enabled: verificaBollettino e sendOutcome
    Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = '$postepay_toggle_enabled' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | postepay_in_poste  |
    And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'POSTE3' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | lista_canali_poste |
    And waiting after triggered refresh job ALL
    And update for table CANALI_NODO with parameter VERSIONE_PRIMITIVE = '2' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | OBJ_ID     | 14748        |
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 302#iuv#     |
    And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
      | outcome            | OK                      |
      | amount             | 10.00                   |
      | options            | EQ                      |
      | allCCP             | false                   |
      | paymentDescription | Pagamento PostePay Test |
      | fiscalCodePA       | #creditor_institution_code# |
      | companyName        | companyName             |
    And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
      | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
    And from body with datatable vertical paGetPayment_full initial XML paGetPayment
      | outcome                     | OK                             |
      | creditorReferenceId         | 02$iuv                        |
      | paymentAmount               | 10.00                          |
      | dueDate                     | 2021-12-31                     |
      | description                 | pagamentoPostePay              |
      | entityUniqueIdentifierType  | G                              |
      | entityUniqueIdentifierValue | 77777777777                    |
      | fullName                    | Massimo Test                   |
      | transferAmount              | 10.00                          |
      | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
      | IBAN                        | IT45R0760103200000000001016    |
      | remittanceInformation       | testPostePay                   |
      | transferCategory            | PostePay                       |
      | transferType                | POSTAL                         |
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
      | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                  | outcome |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
      | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                  | outcome |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'false' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | postepay_in_poste  |
    And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = '' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | postepay_in_poste  |
    And waiting after triggered refresh job ALL

  @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @POSTEPAY @POSTEPAY_TOGGLE @POSTEPAY_TOGGLE_02
  Scenario: POSTEPAY_TOGGLE_02 PostePay Disabled: verificaBollettino e sendOutcome con toggle=TRUE
    Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'true' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | postepay_in_poste  |
    And waiting after triggered refresh job ALL
    And update for table CANALI_NODO with parameter VERSIONE_PRIMITIVE = '2' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | OBJ_ID     | 14748        |
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP      | idBrokerPSP      | idChannel                    | password   | ccPost    | noticeNumber |
      | #pspPoste# | #brokerPspPoste# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #ccPoste# | 302#iuv#     |
    And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
      | outcome            | OK                      |
      | amount             | 10.00                   |
      | options            | EQ                      |
      | allCCP             | false                   |
      | paymentDescription | Pagamento PostePay Test |
      | fiscalCodePA       | #creditor_institution_code# |
      | companyName        | companyName             |
    And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP      | idBrokerPSP      | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
      | #pspPoste# | #brokerPspPoste# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
    And from body with datatable vertical paGetPayment_full initial XML paGetPayment
      | outcome                     | OK                             |
      | creditorReferenceId         | 02$iuv                        |
      | paymentAmount               | 10.00                          |
      | dueDate                     | 2021-12-31                     |
      | description                 | pagamentoPostePay              |
      | entityUniqueIdentifierType  | G                              |
      | entityUniqueIdentifierValue | 77777777777                    |
      | fullName                    | Massimo Test                   |
      | transferAmount              | 10.00                          |
      | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
      | IBAN                        | IT45R0760103200000000001016    |
      | remittanceInformation       | testPostePay                   |
      | transferCategory            | PostePay                       |
      | transferType                | PAGOPA                         |
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
      | idPSP      | idBrokerPSP      | idChannel                    | password   | paymentToken                                  | outcome |
      | #pspPoste# | #brokerPspPoste# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
     Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'false' on db nodo_cfg with where datatable horizontal
       | where_keys | where_values       |
       | CONFIG_KEY | postepay_in_poste  |
     And waiting after triggered refresh job ALL
