Feature: MBD syntax checks in sendPaymentOutcomeV2 291

   Background:
      Given systems up


   @ALL @PRIMITIVE @NMU @NMU_SPOV2_MBD_SYN @NMU_SPOV2_MBD_SYN_1
   # PPT_SINTASSI_XSD error on sendPaymentOutcomeV2 for wrong syntax in MBD
   Scenario Outline: Check PPT_SINTASSI_XSD error
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
         | to_change     | Y                                            |
      And <elem> with <value> in bollo
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_XSD of sendPaymentOutcomeV2 response
      And check description is Errore validazione marca da bollo of sendPaymentOutcomeV2 response
      Examples:
         | elem                   | value                         | Test    |
         | PSP                    | None                          | Test 1  |
         | PSP                    | Empty                         | Test 2  |
         | PSP                    | RemoveParent                  | Test 3  |
         | CodiceFiscale          | None                          | Test 4  |
         | CodiceFiscale          | Empty                         | Test 5  |
         | Denominazione          | None                          | Test 6  |
         | Denominazione          | Empty                         | Test 7  |
         | IUBD                   | None                          | Test 8  |
         | IUBD                   | Empty                         | Test 9  |
         | OraAcquisto            | None                          | Test 10 |
         | OraAcquisto            | Empty                         | Test 11 |
         | OraAcquisto            | 15:00:44.659                  | Test 12 |
         | OraAcquisto            | 2022-02-06                    | Test 13 |
         | OraAcquisto            | 02-06-2022T15:00:44.659+01:00 | Test 14 |
         | Importo                | None                          | Test 15 |
         | Importo                | Empty                         | Test 16 |
         | Importo                | 5.845                         | Test 17 |
         | Importo                | 5,84                          | Test 18 |
         | TipoBollo              | None                          | Test 19 |
         | TipoBollo              | Empty                         | Test 20 |
         | TipoBollo              | 02                            | Test 21 |
         | ImprontaDocumento      | None                          | Test 22 |
         | ImprontaDocumento      | Empty                         | Test 23 |
         | ImprontaDocumento      | RemoveParent                  | Test 24 |
         | DigestMethod           | None                          | Test 25 |
         | ns2:DigestValue        | None                          | Test 26 |
         | ns2:DigestValue        | s                             | Test 27 |
         | Signature              | None                          | Test 28 |
         | Signature              | Empty                         | Test 29 |
         | SignedInfo             | None                          | Test 30 |
         | SignedInfo             | Empty                         | Test 31 |
         | SignedInfo             | RemoveParent                  | Test 32 |
         | CanonicalizationMethod | None                          | Test 33 |
         | SignatureMethod        | None                          | Test 34 |
         | Reference              | None                          | Test 35 |
         | Reference              | Empty                         | Test 36 |
         | Transforms             | Empty                         | Test 37 |
         | Transforms             | RemoveParent                  | Test 38 |
         | Transform              | None                          | Test 39 |
         | DigestValue            | None                          | Test 40 |
         | DigestValue            | s                             | Test 41 |
         | SignatureValue         | None                          | Test 42 |
         | SignatureValue         | s                             | Test 43 |
         | KeyInfo                | Empty                         | Test 44 |
         | KeyInfo                | RemoveParent                  | Test 45 |
         | X509Data               | None                          | Test 46 |
         | X509Data               | Empty                         | Test 47 |
         | X509Data               | RemoveParent                  | Test 48 |
         | X509Certificate        | s                             | Test 49 |
         | X509CRL                | s                             | Test 50 |




   @ALL @PRIMITIVE @NMU @NMU_SPOV2_MBD_SYN @NMU_SPOV2_MBD_SYN_2
   # sendPaymentOutcomeV2 OK
   Scenario Outline: Check sendPaymentOutcomeV2 OK
      Given MB generation MBD_generation with datatable vertical
         | CodiceFiscale | #creditor_institution_code#                  |
         | Denominazione | #psp#                                        |
         | IUBD          | #iubd#                                       |
         | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
         | Importo       | 5.00                                         |
         | TipoBollo     | 01                                           |
         | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
         | to_change     | Y                                            |
      And <elem> with <value> in bollo
      And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full initial XML sendPaymentOutcomeV2
         | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                     | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
         | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      | creditCard    | 2.00 | $bollo        | 1          |
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And checks faultCode is not PPT_SINTASSI_XSD of sendPaymentOutcomeV2 response
      And checks faultCode is not PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      And checks faultCode is not PPT_SEMANTICA of sendPaymentOutcomeV2 response
      Examples:
         | elem            | value | Test    |
         | Importo         | 5     | Test 51 |
         | Importo         | 5.8   | Test 52 |
         | ns2:DigestValue | Empty | Test 53 |
         | DigestValue     | Empty | Test 54 |
         | SignatureValue  | Empty | Test 55 |
         | Transforms      | None  | Test 56 |
         | KeyInfo         | None  | Test 57 |
         | X509Certificate | None  | Test 58 |
         | X509Certificate | Empty | Test 59 |
         | X509CRL         | None  | Test 60 |
         | X509CRL         | Empty | Test 61 |