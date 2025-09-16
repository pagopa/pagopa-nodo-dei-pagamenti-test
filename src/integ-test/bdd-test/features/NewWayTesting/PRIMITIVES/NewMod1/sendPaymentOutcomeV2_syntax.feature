Feature: syntax checks for sendPaymentOutcomeV2 969

   Background:
      Given systems up


   @ALL @PRIMITIVE @NMU @NMU_SPOV2_SYN @NMU_SPOV2_SYN_1
   # SIN_SPO_00
   Scenario: SIN_SPO_00
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      And details with None in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And checks faultCode is not PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      And checks faultCode is not PPT_SYSTEM_ERROR of sendPaymentOutcomeV2 response





   @ALL @PRIMITIVE @NMU @NMU_SPOV2_SYN @NMU_SPOV2_SYN_2
   # attribute value check
   Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      And <attribute> set <value> for <elem> in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      Examples:
         | elem             | attribute     | value                                     | soapUI test |
         | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_SPO_01  |





   @ALL @PRIMITIVE @NMU @NMU_SPOV2_SYN @NMU_SPOV2_SYN_3
   # element value check
   Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full_with_idempotency initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      And <elem> with <value> in sendPaymentOutcomeV2
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      Examples:
         | elem                            | value                                                                                                                                                                                                                                                             | soapUI test            |
         | soapenv:Body                    | None                                                                                                                                                                                                                                                              | SIN_SPO_02             |
         | idPSP                           | None                                                                                                                                                                                                                                                              | SIN_SPO_05             |
         | idPSP                           | Empty                                                                                                                                                                                                                                                             | SIN_SPO_06             |
         | idPSP                           | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_07             |
         | idBrokerPSP                     | Empty                                                                                                                                                                                                                                                             | SIN_SPO_09             |
         | idBrokerPSP                     | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_10             |
         | idChannel                       | None                                                                                                                                                                                                                                                              | SIN_SPO_11             |
         | idChannel                       | Empty                                                                                                                                                                                                                                                             | SIN_SPO_12             |
         | idChannel                       | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_13             |
         | password                        | None                                                                                                                                                                                                                                                              | SIN_SPO_14             |
         | password                        | Empty                                                                                                                                                                                                                                                             | SIN_SPO_15             |
         | password                        | 1234567                                                                                                                                                                                                                                                           | SIN_SPO_16             |
         | password                        | 1234567890123456                                                                                                                                                                                                                                                  | SIN_SPO_17             |
         | paymentTokens                   | None                                                                                                                                                                                                                                                              | SIN_SPO_18             |
         | paymentTokens                   | Empty                                                                                                                                                                                                                                                             | SIN_SPO_19             |
         | paymentToken                    | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_19.1           |
         | paymentToken                    | Empty                                                                                                                                                                                                                                                             | SIN_SPO_19.2           |
         | outcome                         | None                                                                                                                                                                                                                                                              | SIN_SPO_20             |
         | outcome                         | Empty                                                                                                                                                                                                                                                             | SIN_SPO_21             |
         | outcome                         | O%                                                                                                                                                                                                                                                                | SIN_SPO_22             |
         | outcome                         | O                                                                                                                                                                                                                                                                 | SIN_SPO_22             |
         | outcome                         | OKK                                                                                                                                                                                                                                                               | SIN_SPO_22             |
         | outcome                         | O1                                                                                                                                                                                                                                                                | SIN_SPO_22             |
         | paymentMethod                   | None                                                                                                                                                                                                                                                              | SIN_SPO_23             |
         | paymentMethod                   | Empty                                                                                                                                                                                                                                                             | SIN_SPO_24             |
         | paymentMethod                   | fail                                                                                                                                                                                                                                                              | SIN_SPO_25             |
         | paymentChannel                  | Empty                                                                                                                                                                                                                                                             | SIN_SPO_27             |
         | paymentChannel                  | fail                                                                                                                                                                                                                                                              | SIN_SPO_28             |
         | fee                             | None                                                                                                                                                                                                                                                              | SIN_SPO_29             |
         | fee                             | Empty                                                                                                                                                                                                                                                             | SIN_SPO_30             |
         | fee                             | 2,00                                                                                                                                                                                                                                                              | SIN_SPO_31             |
         | fee                             | 2.134                                                                                                                                                                                                                                                             | SIN_SPO_32             |
         | fee                             | 2.5                                                                                                                                                                                                                                                               | SIN_SPO_33             |
         | fee                             | 1000000000.00                                                                                                                                                                                                                                                     | SIN_SPO_34             |
         | payer                           | RemoveParent                                                                                                                                                                                                                                                      | SIN_SPO_37             |
         | payer                           | Empty                                                                                                                                                                                                                                                             | SIN_SPO_37             |
         | uniqueIdentifier                | None                                                                                                                                                                                                                                                              | SIN_SPO_38             |
         | uniqueIdentifier                | RemoveParent                                                                                                                                                                                                                                                      | SIN_SPO_40             |
         | uniqueIdentifier                | Empty                                                                                                                                                                                                                                                             | SIN_SPO_40             |
         | entityUniqueIdentifierType      | None                                                                                                                                                                                                                                                              | SIN_SPO_41             |
         | entityUniqueIdentifierType      | Empty                                                                                                                                                                                                                                                             | SIN_SPO_42             |
         | entityUniqueIdentifierType      | FF                                                                                                                                                                                                                                                                | SIN_SPO_43             |
         | entityUniqueIdentifierType      | L                                                                                                                                                                                                                                                                 | SIN_SPO_44             |
         | entityUniqueIdentifierValue     | None                                                                                                                                                                                                                                                              | SIN_SPO_45             |
         | entityUniqueIdentifierValue     | Empty                                                                                                                                                                                                                                                             | SIN_SPO_46             |
         | entityUniqueIdentifierValue     | 12345678901234567                                                                                                                                                                                                                                                 | SIN_SPO_47             |
         | fullName                        | None                                                                                                                                                                                                                                                              | SIN_SPO_48             |
         | fullName                        | Empty                                                                                                                                                                                                                                                             | SIN_SPO_49             |
         | fullName                        | 12345678901234567890123456789012345612345678901234567890123456789012345                                                                                                                                                                                           | SIN_SPO_50             |
         | streetName                      | Empty                                                                                                                                                                                                                                                             | SIN_SPO_52             |
         | streetName                      | 12345678901234567890123456789012345612345678901234567890123456789012345                                                                                                                                                                                           | SIN_SPO_53             |
         | civicNumber                     | Empty                                                                                                                                                                                                                                                             | SIN_SPO_55             |
         | civicNumber                     | 12345678901234567                                                                                                                                                                                                                                                 | SIN_SPO_56             |
         | postalCode                      | Empty                                                                                                                                                                                                                                                             | SIN_SPO_58             |
         | postalCode                      | 12345678901234567                                                                                                                                                                                                                                                 | SIN_SPO_59             |
         | city                            | Empty                                                                                                                                                                                                                                                             | SIN_SPO_61             |
         | city                            | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_62             |
         | stateProvinceRegion             | Empty                                                                                                                                                                                                                                                             | SIN_SPO_64             |
         | stateProvinceRegion             | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_65             |
         | country                         | Empty                                                                                                                                                                                                                                                             | SIN_SPO_67             |
         | country                         | ITT                                                                                                                                                                                                                                                               | SIN_SPO_68             |
         | country                         | it                                                                                                                                                                                                                                                                | SIN_SPO_69             |
         | e-mail                          | Empty                                                                                                                                                                                                                                                             | SIN_SPO_71             |
         | e-mail                          | provatest.it@                                                                                                                                                                                                                                                     | SIN_SPO_72             |
         | e-mail                          | prova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777prrova77777777prova@t.it | SIN_SPO_73             |
         | applicationDate                 | None                                                                                                                                                                                                                                                              | SIN_SPO_74             |
         | applicationDate                 | Empty                                                                                                                                                                                                                                                             | SIN_SPO_75             |
         | applicationDate                 | 20-12-2021                                                                                                                                                                                                                                                        | SIN_SPO_76             |
         | applicationDate                 | 20-12-21                                                                                                                                                                                                                                                          | SIN_SPO_76             |
         | applicationDate                 | 21-12-09                                                                                                                                                                                                                                                          | SIN_SPO_76             |
         | transferDate                    | None                                                                                                                                                                                                                                                              | SIN_SPO_77             |
         | transferDate                    | Empty                                                                                                                                                                                                                                                             | SIN_SPO_78             |
         | transferDate                    | 20-12-2021                                                                                                                                                                                                                                                        | SIN_SPO_79             |
         | transferDate                    | 20-12-21                                                                                                                                                                                                                                                          | SIN_SPO_79             |
         | transferDate                    | 21-12-09                                                                                                                                                                                                                                                          | SIN_SPO_79             |
         | idempotencyKey                  | Empty                                                                                                                                                                                                                                                             | SIN_SPO_81             |
         | idempotencyKey                  | 70000000001.1244565744                                                                                                                                                                                                                                            | SIN_SPO_82             |
         | idempotencyKey                  | 70000000001_%244565744                                                                                                                                                                                                                                            | SIN_SPO_82             |
         | idempotencyKey                  | 70000000001-1244565744                                                                                                                                                                                                                                            | SIN_SPO_82             |
         | idempotencyKey                  | 1244565768_70000000001                                                                                                                                                                                                                                            | SIN_SPO_82             |
         | idempotencyKey                  | 1244565744                                                                                                                                                                                                                                                        | SIN_SPO_82             |
         | idempotencyKey                  | 700000000011244565744                                                                                                                                                                                                                                             | SIN_SPO_82             |
         | idempotencyKey                  | 70000000001_12345678901                                                                                                                                                                                                                                           | SIN_SPO_83             |
         | idempotencyKey                  | 70000000001_124456578                                                                                                                                                                                                                                             | SIN_SPO_84             |
         | idempotencyKey                  | 700ABCD17E000hj123_12345678901                                                                                                                                                                                                                                    | SIN_SPO_83             |
         | idempotencyKey                  | A1_124456578                                                                                                                                                                                                                                                      | SIN_SPO_84             |
         | idempotencyKey                  | 700ABCD17E000hj1234_1234567890                                                                                                                                                                                                                                    | SIN_SPO_83             |
         | idempotencyKey                  | A_1244565784                                                                                                                                                                                                                                                      | SIN_SPO_84             |
         | marcheDaBollo                   | Empty                                                                                                                                                                                                                                                             | # marca da bollo 1     |
         | marcaDaBollo                    | Empty                                                                                                                                                                                                                                                             | # marca da bollo 2     |
         | idTransfer                      | None                                                                                                                                                                                                                                                              | # marca da bollo 3     |
         | idTransfer                      | Empty                                                                                                                                                                                                                                                             | # marca da bollo 4     |
         | idTransfer                      | 6                                                                                                                                                                                                                                                                 | # marca da bollo 5     |
         | idTransfer                      | a                                                                                                                                                                                                                                                                 | # marca da bollo 6     |
         | MBDAttachment                   | None                                                                                                                                                                                                                                                              | # marca da bollo 7     |
         | MBDAttachment                   | s                                                                                                                                                                                                                                                                 | # marca da bollo 9     |





   @ALL @PRIMITIVE @NMU @NMU_SPOV2_SYN @NMU_SPOV2_SYN_4
   #  the syntax check is OK (check that the error is not PPT_SINTASSI_EXTRAXSD). The SPOV2 outcome is KO though because the payment has not been activated
   Scenario Outline: OK syntax checks
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      And <elem> with <value> in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And checks faultCode is not PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      Examples:
         | elem                 | value       | soapUI test             |
         | paymentMethod        | cash        | SIN_SPO_25              |
         | paymentMethod        | creditCard  | SIN_SPO_25              |
         | paymentMethod        | bancomat    | SIN_SPO_25              |
         | paymentMethod        | other       | SIN_SPO_25              |
         | paymentChannel       | None        | SIN_SPO_26              |
         | paymentChannel       | frontOffice | SIN_SPO_28              |
         | paymentChannel       | atm         | SIN_SPO_28              |
         | paymentChannel       | onLine      | SIN_SPO_28              |
         | paymentChannel       | other       | SIN_SPO_28              |
         | payer                | None        | SIN_SPO_35              |
         | streetName           | None        | SIN_SPO_51              |
         | civicNumber          | None        | SIN_SPO_54              |
         | postalCode           | None        | SIN_SPO_57              |
         | city                 | None        | SIN_SPO_60              |
         | stateProvinceRegion  | None        | SIN_SPO_63              |
         | country              | None        | SIN_SPO_66              |
         | marcheDaBollo        | None        | # marca da bollo 10     |





   @ALL @PRIMITIVE @NMU @NMU_SPOV2_SYN @NMU_SPOV2_SYN_5
   # SIN_SPO_19.3
   Scenario: SIN_SPO_19.3
      Given from body with datatable vertical sendPaymentOutcomeV2Body_4paymentToken_idempotency_full initial XML sendPaymentOutcomeV2
         | idPSP          | #psp#                         |
         | idBrokerPSP    | #psp#                         |
         | idChannel      | #canale_versione_primitive_2# |
         | password       | #password#                    |
         | payToken1      | 1213123423254r4r44dfwqfdf     |
         | payToken2      | 1213123423254r4r44dfwqfda     |
         | payToken3      | 1213123423254r4r44dfwqfdb     |
         | payToken4      | 1213123423254r4r44dfwqfdc     |
         | outcome        | OK                            |
         | idempotencyKey | #idempotency_key#             |
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response




   # marca da bollo 11 - MBD token None  -->  PPT_SINTASSI_EXTRAXSD
   @ALL @PRIMITIVE @NMU @NMU_SPOV2_SYN @NMU_SPOV2_SYN_6
   Scenario: execute sendPaymentOutcomeV2 MBD token None
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_without_token_MBD initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response


   # marca da bollo 12 - MBD token Empty  -->  PPT_SINTASSI_EXTRAXSD
   @ALL @PRIMITIVE @NMU @NMU_SPOV2_SYN @NMU_SPOV2_SYN_7
   Scenario: execute sendPaymentOutcomeV2 MBD token Empty
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_token_MBD_empty initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response


   # marca da bollo 13 - MBD token long  -->  PPT_SINTASSI_EXTRAXSD
   @ALL @PRIMITIVE @NMU @NMU_SPOV2_SYN @NMU_SPOV2_SYN_8
   Scenario: execute sendPaymentOutcomeV2 MBD token long
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full_token_MBD_too_long initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response




   @ALL @PRIMITIVE @NMU @NMU_SPOV2_SYN @NMU_SPOV2_SYN_9
   # marca da bollo 8 - MBDAttachment Empty --> PPT_SINTASSI_XSD
   Scenario: execute sendPaymentOutcomeV2 MBDAttachment Empty
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      And MBDAttachment with Empty in sendPaymentOutcomeV2
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_XSD of sendPaymentOutcomeV2 response