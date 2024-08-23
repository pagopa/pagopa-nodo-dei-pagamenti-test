Feature: Syntax checks for paGetPaymentRes - KO 1384

   Background:
      Given systems up
      And initial XML activatePaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header />
            <soapenv:Body>
               <nod:activatePaymentNoticeReq>
                  <idPSP>#psp#</idPSP>
                  <idBrokerPSP>#psp#</idBrokerPSP>
                  <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
                  <password>pwdpwdpwd</password>
                  <idempotencyKey>#idempotency_key#</idempotencyKey>
                  <qrCode>
                     <fiscalCode>#creditor_institution_code#</fiscalCode>
                     <noticeNumber>#notice_number#</noticeNumber>
                  </qrCode>
                  <amount>10.00</amount>
                  <dueDate>2021-12-31</dueDate>
                  <paymentNote>causale</paymentNote>
               </nod:activatePaymentNoticeReq>
            </soapenv:Body>
         </soapenv:Envelope>
         """
      

   @ALL @PRIMITIVE @NM3
   # element value check
   Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
      Given initial XML paGetPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
               <paf:paGetPaymentRes>
                  <outcome>#outcome#</outcome>
                  <fault>
                     <faultCode>#faultCode#</faultCode>
                     <faultString>#faultString#</faultString>
                     <id>#id#</id>
                     <description>#description#</description>
                  </fault>
               </paf:paGetPaymentRes>
            </soapenv:Body>
         </soapenv:Envelope>
         """
      And <elem> with <tagvalue> in paGetPayment
      And if outcome is KO set fault to None in paGetPayment
      And EC replies to nodo-dei-pagamenti with the paGetPayment
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is KO of activatePaymentNotice response
      And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response
      Examples:
         | elem                | tagvalue     | soapUI test |
         | soapenv:Body        | Empty        | SIN_PGPR_02 |
         | soapenv:Body        | None         | SIN_PGPR_03 |
         | soapenv:Body        | RemoveParent | SIN_PGPR_04 |
         | paf:paGetPaymentRes | None         | SIN_PGPR_05 |
         | paf:paGetPaymentRes | Empty        | SIN_PGPR_06 |
         | outcome             | None         | SIN_PGPR_07 |
         | outcome             | Empty        | SIN_PGPR_08 |
         | outcome             | PP           | SIN_PGPR_09 |
         | outcome             | KO           | SIN_PGPR_10 |

   @ALL @PRIMITIVE @NM3
   Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
      Given initial XML paGetPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header />
            <soapenv:Body>
               <paf:paGetPaymentRes>
                  <outcome>OK</outcome>
                  <data>
                     <creditorReferenceId>$iuv</creditorReferenceId>
                     <paymentAmount>10.00</paymentAmount>
                     <dueDate>2021-12-31</dueDate>
                     <!--Optional:-->
                     <retentionDate>2021-12-31T12:12:12</retentionDate>
                     <!--Optional:-->
                     <lastPayment>1</lastPayment>
                     <description>description</description>
                     <!--Optional:-->
                     <companyName>company</companyName>
                     <!--Optional:-->
                     <officeName>office</officeName>
                     <debtor>
                        <uniqueIdentifier>
                           <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                           <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
                        </uniqueIdentifier>
                        <fullName>paGetPaymentName</fullName>
                        <!--Optional:-->
                        <streetName>paGetPaymentStreet</streetName>
                        <!--Optional:-->
                        <civicNumber>paGetPayment99</civicNumber>
                        <!--Optional:-->
                        <postalCode>20155</postalCode>
                        <!--Optional:-->
                        <city>paGetPaymentCity</city>
                        <!--Optional:-->
                        <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
                        <!--Optional:-->
                        <country>IT</country>
                        <!--Optional:-->
                        <e-mail>paGetPayment@test.it</e-mail>
                     </debtor>
                     <!--Optional:-->
                     <transferList>
                     <!--1 to 5 repetitions:-->
                        <transfer>
                           <idTransfer>1</idTransfer>
                           <transferAmount>10.00</transferAmount>
                           <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                           <IBAN>IT45R0760103200000000001016</IBAN>
                           <remittanceInformation>testPaGetPayment</remittanceInformation>
                           <transferCategory>paGetPaymentTest</transferCategory>
                        </transfer>
                     </transferList>
                     <!--Optional:-->
                     <metadata>
                     <!--1 to 10 repetitions:-->
                        <mapEntry>
                           <key>1</key>
                           <value>22</value>
                        </mapEntry>
                     </metadata>
                  </data>
               </paf:paGetPaymentRes>
            </soapenv:Body>
         </soapenv:Envelope>
         """
      And <tag> with <tagvalue> in paGetPayment
      And EC replies to nodo-dei-pagamenti with the paGetPayment
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is KO of activatePaymentNotice response
      And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response
      Examples:
         | tag                         | tagvalue                                                                                                                                                                                                                                                          | soapUI test   |
         | data                        | None                                                                                                                                                                                                                                                              | SIN_PGPR_11   |
         | data                        | RemoveParent                                                                                                                                                                                                                                                      | SIN_PGPR_12   |
         | data                        | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_13   |
         | creditorReferenceId         | None                                                                                                                                                                                                                                                              | SIN_PGPR_14   |
         | creditorReferenceId         | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_15   |
         | creditorReferenceId         | test di prova per una lunghezza>36char                                                                                                                                                                                                                            | SIN_PGPR_16   |
         | paymentAmount               | None                                                                                                                                                                                                                                                              | SIN_PGPR_17   |
         | paymentAmount               | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_18   |
         | paymentAmount               | 0.00                                                                                                                                                                                                                                                              | SIN_PGPR_18.1 |
         | paymentAmount               | 11,34                                                                                                                                                                                                                                                             | SIN_PGPR_19   |
         | paymentAmount               | 11.342                                                                                                                                                                                                                                                            | SIN_PGPR_20   |
         | paymentAmount               | 11.3                                                                                                                                                                                                                                                              | SIN_PGPR_21   |
         | paymentAmount               | 1219087657.34                                                                                                                                                                                                                                                     | SIN_PGPR_22   |
         | dueDate                     | None                                                                                                                                                                                                                                                              | SIN_PGPR_23   |
         | dueDate                     | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_24   |
         | dueDate                     | 12-28-2022                                                                                                                                                                                                                                                        | SIN_PGPR_25   |
         | dueDate                     | 12-09-22                                                                                                                                                                                                                                                          | SIN_PGPR_25   |
         | dueDate                     | 12-08-2022T12:00:678                                                                                                                                                                                                                                              | SIN_PGPR_25   |
         | retentionDate               | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_27   |
         | retentionDate               | 12-28-2022                                                                                                                                                                                                                                                        | SIN_PGPR_28   |
         | retentionDate               | 12-09-22                                                                                                                                                                                                                                                          | SIN_PGPR_28   |
         | retentionDate               | 12-08-2022T12:00:678                                                                                                                                                                                                                                              | SIN_PGPR_28   |
         | lastPayment                 | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_30   |
         | lastPayment                 | 2                                                                                                                                                                                                                                                                 | SIN_PGPR_31   |
         | description                 | None                                                                                                                                                                                                                                                              | SIN_PGPR_32   |
         | description                 | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_33   |
         | description                 | test di prova per una lunghezza superiore a 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                                                                   | SIN_PGPR_34   |
         | companyName                 | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_39   |
         | companyName                 | test di prova per una lunghezza superiore a 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                                                                   | SIN_PGPR_40   |
         | officeName                  | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_42   |
         | officeName                  | test di prova per una lunghezza superiore a 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                                                                   | SIN_PGPR_43   |
         | debtor                      | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_44   |
         | debtor                      | None                                                                                                                                                                                                                                                              | SIN_PGPR_45   |
         | debtor                      | RemoveParent                                                                                                                                                                                                                                                      | SIN_PGPR_46   |
         | uniqueIdentifier            | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_47   |
         | uniqueIdentifier            | None                                                                                                                                                                                                                                                              | SIN_PGPR_48   |
         | uniqueIdentifier            | RemoveParent                                                                                                                                                                                                                                                      | SIN_PGPR_49   |
         | entityUniqueIdentifierType  | None                                                                                                                                                                                                                                                              | SIN_PGPR_50   |
         | entityUniqueIdentifierType  | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_51   |
         | entityUniqueIdentifierType  | H                                                                                                                                                                                                                                                                 | SIN_PGPR_52   |
         | entityUniqueIdentifierValue | None                                                                                                                                                                                                                                                              | SIN_PGPR_53   |
         | entityUniqueIdentifierValue | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_54   |
         | entityUniqueIdentifierValue | lunghezza >16char                                                                                                                                                                                                                                                 | SIN_PGPR_55   |
         | fullName                    | None                                                                                                                                                                                                                                                              | SIN_PGPR_56   |
         | fullName                    | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_57   |
         | fullName                    | test di prova per una lunghezza superiore a 70 caratteri alfanumerici ,                                                                                                                                                                                           | SIN_PGPR_58   |
         | streetName                  | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_60   |
         | streetName                  | test di prova per una lunghezza superiore a 70 caratteri alfanumerici ,                                                                                                                                                                                           | SIN_PGPR_61   |
         | civicNumber                 | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_63   |
         | civicNumber                 | lunghezza >16char                                                                                                                                                                                                                                                 | SIN_PGPR_64   |
         | postalCode                  | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_66   |
         | postalCode                  | lunghezza >16char                                                                                                                                                                                                                                                 | SIN_PGPR_67   |
         | city                        | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_69   |
         | city                        | test di prova per una lunghez>35char                                                                                                                                                                                                                              | SIN_PGPR_70   |
         | stateProvinceRegion         | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_72   |
         | stateProvinceRegion         | test di prova per una lunghez>35char                                                                                                                                                                                                                              | SIN_PGPR_73   |
         | country                     | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_75   |
         | country                     | ITA                                                                                                                                                                                                                                                               | SIN_PGPR_76   |
         | country                     | it                                                                                                                                                                                                                                                                | SIN_PGPR_77   |
         | e-mail                      | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_79   |
         | e-mail                      | prova%gmail.com                                                                                                                                                                                                                                                   | SIN_PGPR_80   |
         | e-mail                      | provaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovapr@gmail.com | SIN_PGPR_81   |
         | transferList                | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_82   |
         | transferList                | None                                                                                                                                                                                                                                                              | SIN_PGPR_83   |
         | transferList                | RemoveParent                                                                                                                                                                                                                                                      | SIN_PGPR_84   |
         | transfer                    | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_85   |
         | transfer                    | None                                                                                                                                                                                                                                                              | SIN_PGPR_86   |
         | transfer                    | Occurrences,6                                                                                                                                                                                                                                                     | SIN_PGPR_87   |
         | idTransfer                  | None                                                                                                                                                                                                                                                              | SIN_PGPR_88   |
         | idTransfer                  | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_89   |
         | idTransfer                  | 11                                                                                                                                                                                                                                                                | SIN_PGPR_90   |
         | idTransfer                  | 6                                                                                                                                                                                                                                                                 | SIN_PGPR_91   |
         | idTransfer                  | a                                                                                                                                                                                                                                                                 | SIN_PGPR_92   |
         | transferAmount              | None                                                                                                                                                                                                                                                              | SIN_PGPR_93   |
         | transferAmount              | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_94   |
         | transferAmount              | 0.00                                                                                                                                                                                                                                                              | SIN_PGPR_94.1 |
         | transferAmount              | 11,34                                                                                                                                                                                                                                                             | SIN_PGPR_95   |
         | transferAmount              | 11.342                                                                                                                                                                                                                                                            | SIN_PGPR_96   |
         | transferAmount              | 11.3                                                                                                                                                                                                                                                              | SIN_PGPR_97   |
         | transferAmount              | 1219087657.34                                                                                                                                                                                                                                                     | SIN_PGPR_98   |
         | transferAmount              | ?                                                                                                                                                                                                                                                                 | SIN_PGPR_99   |
         | transferAmount              | ?                                                                                                                                                                                                                                                                 | SIN_PGPR_100  |
         | fiscalCodePA                | None                                                                                                                                                                                                                                                              | SIN_PGPR_101  |
         | fiscalCodePA                | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_102  |
         | fiscalCodePA                | 777777777777                                                                                                                                                                                                                                                      | SIN_PGPR_103  |
         | fiscalCodePA                | 7777777777a                                                                                                                                                                                                                                                       | SIN_PGPR_104  |
         | IBAN                        | None                                                                                                                                                                                                                                                              | SIN_PGPR_105  |
         | IBAN                        | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_106  |
         | IBAN                        | test di prova per una lunghezza>35ch                                                                                                                                                                                                                              | SIN_PGPR_107  |
         | remittanceInformation       | None                                                                                                                                                                                                                                                              | SIN_PGPR_108  |
         | remittanceInformation       | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_109  |
         | remittanceInformation       | test di prova per una lunghezza superiore a 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                                                                   | SIN_PGPR_110  |
         | transferCategory            | None                                                                                                                                                                                                                                                              | SIN_PGPR_111  |
         | transferCategory            | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_112  |
         | transferCategory            | test di prova per una lunghezza superiore a 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                                                                   | SIN_PGPR_113  |
         | metadata                    | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_114  |
         | metadata                    | RemoveParent                                                                                                                                                                                                                                                      | SIN_PGPR_116  |
         | mapEntry                    | Empty                                                                                                                                                                                                                                                             | SIN_PGPR_117  |
         | mapEntry                    | None                                                                                                                                                                                                                                                              | SIN_PGPR_118  |
         | mapEntry                    | Occurrences,16                                                                                                                                                                                                                                                    | SIN_PGPR_119  |
         | key                         | None                                                                                                                                                                                                                                                              | SIN_PGPR_120  |
         | value                       | None                                                                                                                                                                                                                                                              | SIN_PGPR_121  |
