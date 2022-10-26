# Il test verifica che il nodo restituisca un KO se la paGetPaymentV2 con marca da bollo non è sintatticamente corretta

Feature: check syntax KO for paGetPaymentV2 with MBD

    Background:
        Given systems up
        And EC new version
        And initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#pspEcommerce#</idPSP>
            <idBrokerPSP>#brokerEcommerce#</idBrokerPSP>
            <idChannel>#canaleEcommerce#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario Outline:
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>9.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <richiestaMarcaDaBollo>
            <hashDocumento>ciao</hashDocumento>
            <tipoBollo>01</tipoBollo>
            <provinciaResidenza>MI</provinciaResidenza>
            </richiestaMarcaDaBollo>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </metadata>
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
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <tag> with <value> in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
        Examples:
            | tag                                   | value                                                                                                                                         
            | outcome                               | None                                                                                                                                          
            | outcome                               | Empty                                                                                                                                         
            | outcome                               | prova                                                                                                                                          
            | creditorReferenceId                   | None                                                                                                                                          
            | creditorReferenceId                   | Empty 
            | creditorReferenceId                   | 123456789012345678901234567890123456
            | paymentAmount                         | None
            | paymentAmount                         | Empty
            | paymentAmount                         | 0.00                                                                               
            | paymentAmount                         | 105,12                                                                                                                                      
            | paymentAmount                         | 105.2                                                                                                                                         
            | paymentAmount                         | 105.256                                                                                                                                       
            | paymentAmount                         | 12ad45rtyu78hj56.44  
            | paymentAmount                         | 1000000000.00
            | dueDate                               | None
            | dueDate                               | Empty
            | dueDate                               | 20-12-2022
            | dueDate                               | 12-20-2022
            | dueDate                               | 2022-12-12T12:23:000
            | retentionDate                         | Empty
            | retentionDate                         | 20-12-2022
            | retentionDate                         | 2021-12-30T
            | retentionDate                         | 12-20-2022
            | lastPayment                           | Empty
            | lastPayment                           | 3
            | description                           | None
            | description                           | Empty
            | description                           | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf
            | companyName                           | Empty
            | companyName                           | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf
            | officeName                            | Empty
            | officeName                            | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf
            | entityUniqueIdentifierType            | None
            | entityUniqueIdentifierType            | Empty
            | entityUniqueIdentifierType            | P
            | entityUniqueIdentifierValue           | None
            | entityUniqueIdentifierValue           | Empty
            | entityUniqueIdentifierValue           | 12ftr4567dghfi89k
            | fullName                              | None
            | fullName                              | Empty
            | fullName                              | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375
            | streetName                            | Empty
            | streetName                            | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375
            | civicNumber                           | Empty
            | civicNumber                           | 1we345ty67ghjkl78
            | postalCode                            | Empty
            | postalCode                            | 12ftr4567dghfi89k
            | city                                  | Empty
            | city                                  | 123456mklo12345678901234567890123456
            | stateProvinceRegion                   | Empty
            | stateProvinceRegion                   | 123456mklo12345678901234567890123456
            | country                               | Empty
            | country                               | ITA
            | country                               | de
            | e-mail                                | Empty
            | e-mail                                | @prova.it
            | e-mail                                | noei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375sanoei38932nfdiou%&ncdoaifer9eukvmptu@prova.it
            | transferAmount                        | None
            | transferAmount                        | Empty
            | transferAmount                        | 0.00
            | transferAmount                        | 10,89
            | transferAmount                        | 12.456
            | transferAmount                        | 1.1
            | transferAmount                        | 1000000000.00
            | transferAmount                        | 60.98
            | fiscalCodePA                          | None
            | fiscalCodePA                          | Empty
            | fiscalCodePA                          | 123409857635
            | fiscalCodePA                          | 123456789rf
            | fiscalCodePA                          | 152436%$789
            | hashDocumento                         | None
            | hashDocumento                         | Empty
            | hashDocumento                         | 10hjkrt
            | hashDocumento                         | noei38932nfdioulgncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv23234fssdafqffd
            | tipoBollo                             | 123
            | tipoBollo                             | None
            | tipoBollo                             | Empty
            | tipoBollo                             | TB
            | tipoBollo                             | 22
            | provinciaResidenza                    | None
            | provinciaResidenza                    | Empty
            | provinciaResidenza                    | MIL
            | provinciaResidenza                    | M
            | provinciaResidenza                    | 12
            | provinciaResidenza                    | rc
            | remittanceInformation                 | None
            | remittanceInformation                 | Empty
            | remittanceInformation                 | sanoei38932nfdiou0pncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf
            | transferCategory                      | None
            | transferCategory                      | Empty
            | transferCategory                      | sanoei38932nfdiou0pncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf
            | fiscalCodePA                          | 17777777477
            | fiscalCodePA                          | 11111122222
            
