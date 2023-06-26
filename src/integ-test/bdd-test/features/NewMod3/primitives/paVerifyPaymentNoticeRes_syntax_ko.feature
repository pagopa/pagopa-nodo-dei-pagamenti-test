Feature: syntax checks for paVerifyPaymentNoticeRes - KO

   Background:
      Given systems up
      And initial XML verifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:verifyPaymentNoticeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>pwdpwdpwd</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>#notice_number#</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And EC new version

   @runnable @independent
   # element value check
   Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
      Given initial XML paVerifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <paf:paVerifyPaymentNoticeRes>
         <outcome>#outcome#</outcome>
         <fault>
         <faultCode>#faultCode#</faultCode>
         <faultString>#faultString#</faultString>
         <id>#id#</id>
         <description>#description#</description>
         </fault>
         </paf:paVerifyPaymentNoticeRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And <elem> with <value> in paVerifyPaymentNotice
      And if outcome is KO set fault to None in paVerifyPaymentNotice
      And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
      When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is KO of verifyPaymentNotice response
      And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of verifyPaymentNotice response
      Examples:
         | elem                         | value        | soapUI test  |
         | soapenv:Body                 | None         | SIN_PVPNR_02 |
         | soapenv:Body                 | Empty        | SIN_PVPNR_03 |
         | paf:paVerifyPaymentNoticeRes | None         | SIN_PVPNR_04 |
         | paf:paVerifyPaymentNoticeRes | RemoveParent | SIN_PVPNR_05 |
         | paf:paVerifyPaymentNoticeRes | Empty        | SIN_PVPNR_06 |
         | outcome                      | None         | SIN_PVPNR_07 |
         | outcome                      | Empty        | SIN_PVPNR_08 |
         | outcome                      | PP           | SIN_PVPNR_09 |
         | outcome                      | KO           | SIN_PVPNR_10 |

   @runnable @independent
   Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
      Given initial XML paVerifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <paf:paVerifyPaymentNoticeRes>
         <outcome>OK</outcome>
         <paymentList>
         <!--1 to 5 repetitions:-->
         <paymentOptionDescription>
         <amount>10.00</amount>
         <options>EQ</options>
         <!--Optional:-->
         <dueDate>2021-12-31</dueDate>
         <!--Optional:-->
         <detailDescription>test</detailDescription>
         <!--Optional:-->
         <allCCP>1</allCCP>
         </paymentOptionDescription>
         </paymentList>
         <!--Optional:-->
         <paymentDescription>test</paymentDescription>
         <!--Optional:-->
         <fiscalCodePA>#fiscalCodePA#</fiscalCodePA>
         <!--Optional:-->
         <companyName>company</companyName>
         <!--Optional:-->
         <officeName>office</officeName>
         </paf:paVerifyPaymentNoticeRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And <tag> with <value> in paVerifyPaymentNotice
      And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
      When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is KO of verifyPaymentNotice response
      And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of verifyPaymentNotice response
      Examples:
         | tag                      | value                                                                                                                                           | soapUI test  |
         | paymentList              | None                                                                                                                                            | SIN_PVPNR_11 |
         | paymentList              | RemoveParent                                                                                                                                    | SIN_PVPNR_12 |
         | paymentList              | Empty                                                                                                                                           | SIN_PVPNR_13 |
         | paymentOptionDescription | None                                                                                                                                            | SIN_PVPNR_14 |
         | paymentOptionDescription | Empty                                                                                                                                           | SIN_PVPNR_15 |
         | paymentOptionDescription | Occurrences,2                                                                                                                                   | SIN_PVPNR_16 |
         | amount                   | None                                                                                                                                            | SIN_PVPNR_17 |
         | amount                   | Empty                                                                                                                                           | SIN_PVPNR_18 |
         | amount                   | 11,34                                                                                                                                           | SIN_PVPNR_19 |
         | amount                   | 11.342                                                                                                                                          | SIN_PVPNR_20 |
         | amount                   | 1219087657.34                                                                                                                                   | SIN_PVPNR_21 |
         | options                  | None                                                                                                                                            | SIN_PVPNR_22 |
         | options                  | Empty                                                                                                                                           | SIN_PVPNR_23 |
         | options                  | KK                                                                                                                                              | SIN_PVPNR_24 |
         | dueDate                  | Empty                                                                                                                                           | SIN_PVPNR_26 |
         | dueDate                  | 12-28-2022                                                                                                                                      | SIN_PVPNR_27 |
         | dueDate                  | 12-09-22                                                                                                                                        | SIN_PVPNR_27 |
         | dueDate                  | 12-08-2022T12:00:678                                                                                                                            | SIN_PVPNR_27 |
         | detailDescription        | Empty                                                                                                                                           | SIN_PVPNR_29 |
         | detailDescription        | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_PVPNR_30 |
         | allCCP                   | None                                                                                                                                            | SIN_PVPNR_31 |
         | allCCP                   | Empty                                                                                                                                           | SIN_PVPNR_32 |
         | allCCP                   | 3                                                                                                                                               | SIN_PVPNR_33 |
         | paymentDescription       | None                                                                                                                                            | SIN_PVPNR_34 |
         | paymentDescription       | Empty                                                                                                                                           | SIN_PVPNR_35 |
         | paymentDescription       | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_PVPNR_36 |
         | fiscalCodePA             | None                                                                                                                                            | SIN_PVPNR_37 |
         | fiscalCodePA             | Empty                                                                                                                                           | SIN_PVPNR_38 |
         | fiscalCodePA             | 123456789012                                                                                                                                    | SIN_PVPNR_39 |
         | fiscalCodePA             | 12345jh%lk9                                                                                                                                     | SIN_PVPNR_40 |
         | companyName              | None                                                                                                                                            | SIN_PVPNR_41 |
         | companyName              | Empty                                                                                                                                           | SIN_PVPNR_42 |
         | companyName              | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_PVPNR_43 |
         | officeName               | Empty                                                                                                                                           | SIN_PVPNR_45 |
         | officeName               | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_PVPNR_46 |
         | allCCP                   | None                                                                                                                                            | SIN_PVPNR_31 |
         | paymentDescription       | None                                                                                                                                            | SIN_PVPNR_34 |
         | fiscalCodePA             | None                                                                                                                                            | SIN_PVPNR_37 |
         | companyName              | None                                                                                                                                            | SIN_PVPNR_41 |

