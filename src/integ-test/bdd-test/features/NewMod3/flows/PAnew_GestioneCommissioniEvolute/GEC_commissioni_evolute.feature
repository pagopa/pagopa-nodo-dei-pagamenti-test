Feature: Commissioni evolute process 1103
    # Reference document: https://pagopa.atlassian.net/wiki/spaces/PAG/pages/544276823/A.T.+Gestione+Evoluta+delle+Commissioni

    Background:
        Given systems up

    Scenario: activatePaymentNoticeV2
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <amount>7001.00</amount>
            <paymentNote>responseFull</paymentNote>
            <paymentMethod>PO</paymentMethod>
            <touchPoint>ATM</touchPoint>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>7001.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>paGetPaymentV2Name</fullName>
            <!--Optional:-->
            <streetName>paGetPaymentV2Street</streetName>
            <!--Optional:-->
            <civicNumber>paGetPaymentV299</civicNumber>
            <!--Optional:-->
            <postalCode>20155</postalCode>
            <!--Optional:-->
            <city>paGetPaymentV2City</city>
            <!--Optional:-->
            <stateProvinceRegion>paGetPaymentV2State</stateProvinceRegion>
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
            <transferAmount>6801.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentV2Test</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>200.00</transferAmount>
            <fiscalCodePA>44444444444</fiscalCodePA>
            <companyName>companyTer</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentV2Test2</transferCategory>
            </transfer>
            </transferList>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

    Scenario: sendPaymentOutcomeV2
        Given initial XML sendPaymentOutcomeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentTokens>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            </paymentTokens>
            <outcome>OK</outcome>
            <!--Optional:-->
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>130.00</fee>
            <primaryCiIncurredFee>20.00</primaryCiIncurredFee>
            <idBundle>1</idBundle>
            <idCiBundle>1</idCiBundle>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>civic</civicNumber>
            <!--Optional:-->
            <postalCode>postal</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>prova@test.it</e-mail>
            </payer>
            <applicationDate>2021-12-12</applicationDate>
            <transferDate>2021-12-11</transferDate>
            </details>
            </nod:sendPaymentOutcomeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    @newfix
    # gec disabled --> fees not triggered
    Scenario: Execute activate 1
        Given nodo-dei-pagamenti has config parameter gec.enabled set to false
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And verify 0 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value ATM of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix @prova
    # sunny day activate
    Scenario: Execute activate 2
        Given update parameter gec.enabled on configuration keys with value true
        And wait 60 seconds after triggered refresh job ALL
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.touchPoint of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedIdBundle of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedIdCiBundle of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedUserFee of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedPaFee of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix
    # activate without paymentMethod and touchPoint --> fees request with paymentMethod = ANY and touchPoint = PSP -->
    # psp in fees response, same of psp in activate request --> fields related to fee retrieved by fees populated with the first occurrence
    Scenario: Execute activate 3
        Given the activatePaymentNoticeV2 scenario executed successfully
        And amount with 7002.00 in activatePaymentNoticeV2
        And paymentMethod with None in activatePaymentNoticeV2
        And touchPoint with None in activatePaymentNoticeV2
        And paymentAmount with 7002.00 in paGetPaymentV2
        And transferAmount with 6802.00 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check suggestedIdBundle is 2 of activatePaymentNoticeV2 response
        And check suggestedIdCiBundle field not exists in activatePaymentNoticeV2 response
        And check suggestedUserFee is 80 of activatePaymentNoticeV2 response
        And check suggestedPaFee is 0 of activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedIdBundle of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedUserFee of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedPaFee of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix
    # psp in fees response different from psp in activate request --> fields related to fee retrieved by fees not populated
    Scenario: Execute activate 4
        Given the activatePaymentNoticeV2 scenario executed successfully
        And amount with 7006.00 in activatePaymentNoticeV2
        And paymentMethod with CP in activatePaymentNoticeV2
        And touchPoint with PSP in activatePaymentNoticeV2
        And paymentAmount with 7006.00 in paGetPaymentV2
        And transferAmount with 6806.00 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check suggestedIdBundle field not exists in activatePaymentNoticeV2 response
        And check suggestedIdCiBundle field not exists in activatePaymentNoticeV2 response
        And check suggestedUserFee field not exists in activatePaymentNoticeV2 response
        And check suggestedPaFee field not exists in activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value CP of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PSP of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix
    # 2 psp in fees response, first different from activate request, second the same --> fields related to fee retrieved by fees populated with the fields from the same psp
    Scenario: Execute activate 5
        Given the activatePaymentNoticeV2 scenario executed successfully
        And amount with 7005.00 in activatePaymentNoticeV2
        And paymentMethod with None in activatePaymentNoticeV2
        And touchPoint with PSP in activatePaymentNoticeV2
        And paymentAmount with 7005.00 in paGetPaymentV2
        And transferAmount with 6805.00 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check suggestedIdBundle is 1 of activatePaymentNoticeV2 response
        And check suggestedIdCiBundle is 1 of activatePaymentNoticeV2 response
        And check suggestedUserFee is 130 of activatePaymentNoticeV2 response
        And check suggestedPaFee is 20 of activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PSP of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedIdBundle of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedIdCiBundle of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedUserFee of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedPaFee of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix
    # fees mock replies with an empty list --> fields related to fees empty in POSITION_ACTIVATE
    Scenario: Execute activate 6
        Given the activatePaymentNoticeV2 scenario executed successfully
        And amount with 7003.00 in activatePaymentNoticeV2
        And touchPoint with BETTING in activatePaymentNoticeV2
        And paymentAmount with 7003.00 in paGetPaymentV2
        And transferAmount with 6803.00 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value BETTING of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix
    # activate with idPsp = AGID_01 --> fees not triggered
    Scenario: Execute activate 7
        Given the activatePaymentNoticeV2 scenario executed successfully
        And idPSP with #psp_AGID# in activatePaymentNoticeV2
        And idBrokerPSP with #broker_AGID# in activatePaymentNoticeV2
        And idChannel with #canale_AGID# in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And verify 0 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value ATM of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1


    # paGetPaymentV2 response not OK --> fees not triggered
    Scenario: activatePaymentNoticeV2 paGetPaymentV2 KO
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            <paymentMethod>PO</paymentMethod>
            <touchPoint>ATM</touchPoint>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>KO</outcome>
            <!--Optional:-->
            <fault>
            <faultCode>PAA_SEMANTICA</faultCode>
            <faultString>chiamata rifiutata</faultString>
            <id>1</id>
            <!--Optional:-->
            <description>chiamata rifiutata</description>
            </fault>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    @newfix
    Scenario: Execute activate 8
        Given the activatePaymentNoticeV2 paGetPaymentV2 KO scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And verify 0 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value ATM of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix
    # retry fees - 400
    Scenario: Execute activate 9
        Given nodo-dei-pagamenti has config parameter gec.fees.maxRetry set to 3
        And the activatePaymentNoticeV2 scenario executed successfully
        And amount with 400.00 in activatePaymentNoticeV2
        And touchPoint with PSP in activatePaymentNoticeV2
        And paymentAmount with 400.00 in paGetPaymentV2
        And transferAmount with 200.00 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        And wait 5 seconds for expiration
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 8 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PSP of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix
    # retry fees - 401
    Scenario: Execute activate 9.1
        Given the activatePaymentNoticeV2 scenario executed successfully
        And amount with 401.00 in activatePaymentNoticeV2
        And touchPoint with PSP in activatePaymentNoticeV2
        And paymentAmount with 401.00 in paGetPaymentV2
        And transferAmount with 201.00 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        And wait 5 seconds for expiration
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 8 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PSP of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix
    # retry fees - 429
    Scenario: Execute activate 9.2
        Given the activatePaymentNoticeV2 scenario executed successfully
        And amount with 429.00 in activatePaymentNoticeV2
        And touchPoint with PSP in activatePaymentNoticeV2
        And paymentAmount with 429.00 in paGetPaymentV2
        And transferAmount with 229.00 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        And wait 5 seconds for expiration
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 8 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PSP of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @newfix
    # retry fees - 500
    Scenario: Execute activate 9.3
        Given the activatePaymentNoticeV2 scenario executed successfully
        And amount with 500.00 in activatePaymentNoticeV2
        And touchPoint with PSP in activatePaymentNoticeV2
        And paymentAmount with 500.00 in paGetPaymentV2
        And transferAmount with 300.00 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        And wait 5 seconds for expiration
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 8 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PSP of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # sendPaymentOutcome - sunny day
    Scenario: Execute activate 10
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @test @company
    Scenario: Execute sendPaymentOutcomeV2
        Given the Execute activate 10 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.primaryCiIncurredFee of the record at column FEE_PA of the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idBundle of the record at column BUNDLE_ID of the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idCiBundle of the record at column BUNDLE_PA_ID of the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.primaryCiIncurredFee of the record at column FEE_PA of the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idBundle of the record at column BUNDLE_ID of the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idCiBundle of the record at column BUNDLE_PA_ID of the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
    # verify paSendRTV2 is sent with fields receipt.fee = POSITION_RECEIPT.FEE, receipt.primaryCiIncurredFee = POSITION_RECEIPT.FEE_PA, receipt.idBundle = POSITION_RECEIPT.BUNDLE_ID, receipt.idCiBundle = POSITION_RECEIPT.BUNDLE_PA_ID


    # sendPaymentOutcome - no fee information in sendPaymentOutcomeV2 request
    Scenario: Execute activate 11
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @test @company
    Scenario: Execute sendPaymentOutcomeV2 2
        Given the Execute activate 11 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And primaryCiIncurredFee with None in sendPaymentOutcomeV2
        And idBundle with None in sendPaymentOutcomeV2
        And idCiBundle with None in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE_PA of the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column BUNDLE_ID of the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column BUNDLE_PA_ID of the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE_PA of the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column BUNDLE_ID of the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column BUNDLE_PA_ID of the table POSITION_RECEIPT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
# verify paSendRTV2 is sent without fields receipt.primaryCiIncurredFee, receipt.idBundle, receipt.idCiBundle