Feature: activatePaymentNoticeV2 - Commissioni evolute process
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
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <amount>7000.00</amount>
            <paymentNote>responseFull</paymentNote>
            <paymentMethod>PO</paymentMethod>
            <touchPoint>ATM</touchPoint>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>11$iuv</creditorReferenceId>
            <paymentAmount>7000.00</paymentAmount>
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
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>6800.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>200.00</transferAmount>
            <fiscalCodePA>44444444444</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest2</transferCategory>
            </transfer>
            </transferList>
            </data>
            </paf:paGetPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPayment

    @skip
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

    # gec disabled --> fees not triggered
    Scenario: Execute activate 1
        Given nodo-dei-pagamenti DEV has config parameter gec.enabled set to false
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
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


    # sunny day
    Scenario: Execute activate 2
        Given nodo-dei-pagamenti DEV has config parameter gec.enabled set to true
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
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


    # activate without paymentMethod and touchPoint --> fees request with paymentMethod = PSP and touchPoint = ANY
    Scenario: Execute activate 3
        Given the activatePaymentNoticeV2 scenario executed successfully
        And paymentMethod with None in activatePaymentNoticeV2
        And touchPoint with None in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        # verify in the fees request that paymentMethod = PSP and touchPoint = ANY. In this case fees mock response contains an empty list
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1


    # psp in fees response different from psp in activate request --> fields related to fee retrieved by fees not populated
    Scenario: Execute activate 4
        Given the activatePaymentNoticeV2 scenario executed successfully
        And paymentAmount with 7001 in activatePaymentNoticeV2
        And touchPoint with ANY in activatePaymentNoticeV2
        And paymentAmount with 7001 in paGetPayment
        And transfer.transferAmount with 6801 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check suggestedIdBundle is None of activatePaymentNoticeV2 response
        And check suggestedIdCiBundle is None of activatePaymentNoticeV2 response
        And check suggestedUserFee is None of activatePaymentNoticeV2 response
        And check suggestedPaFee is None of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value ANY of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1


    # 2 psp in fees response, same of psp in activate request --> fields related to fee retrieved by fees populated with the first occurrence
    Scenario: Execute activate 5
        Given the activatePaymentNoticeV2 scenario executed successfully
        And paymentMethod with PO in activatePaymentNoticeV2
        And touchPoint with ANY in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check suggestedIdBundle is 2 of activatePaymentNoticeV2 response
        And check suggestedIdCiBundle is ANY of activatePaymentNoticeV2 response
        And check suggestedUserFee is 80 of activatePaymentNoticeV2 response
        And check suggestedPaFee is 0 of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value ANY of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedIdBundle of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedIdCiBundle of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedUserFee of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedPaFee of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1


    # 2 psp in fees response, first different from activate request second the same --> fields related to fee retrieved by fees populated with the fields from the same psp
    Scenario: Execute activate 6
        Given the activatePaymentNoticeV2 scenario executed successfully
        And paymentAmount with 7002 in activatePaymentNoticeV2
        And touchPoint with ANY in activatePaymentNoticeV2
        And paymentAmount with 7002 in paGetPayment
        And transfer.transferAmount with 6802 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check suggestedIdBundle is 1 of activatePaymentNoticeV2 response
        And check suggestedIdCiBundle is ANY of activatePaymentNoticeV2 response
        And check suggestedUserFee is 130 of activatePaymentNoticeV2 response
        And check suggestedPaFee is 1 of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value ANY of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedIdBundle of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedIdCiBundle of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedUserFee of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.suggestedPaFee of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1


    # activate with idPsp = AGID_01 --> fees not triggered
    Scenario: Execute activate 7
        Given the activatePaymentNoticeV2 scenario executed successfully
        And idPSP with #psp_AGID# in activatePaymentNoticeV2
        And idBrokerPSP with #broker_AGID# in activatePaymentNoticeV2
        And idChannel with #canale_AGID# in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
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


    # paGetPayment response not OK --> fees not triggered
    Scenario: activatePaymentNoticeV2 paGetPayment KO
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
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            <paymentMethod>PO</paymentMethod>
            <touchPoint>ATM</touchPoint>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>KO</outcome>
            <!--Optional:-->
            <fault>
            <faultCode>PAA_SEMANTICA</faultCode>
            <faultString>chiamata rifiutata</faultString>
            <id>1</id>
            <!--Optional:-->
            <description>chiamata rifiutata</description>
            </fault>
            </paf:paGetPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPayment

    Scenario: Execute activate 8
        Given the activatePaymentNoticeV2 paGetPayment KO scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
        And verify 0 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value ATM of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1


    # # DA COMPLETARE retry - 400   (aggiungere TC anche per gli altri codici errore e caso in cui a una certa risponde ok)
    # Scenario: Execute activate 9
    #     Given the activatePaymentNoticeV2 scenario executed successfully
    # And paymentAmount with 400 in activatePaymentNoticeV2
    # And touchPoint with ANY in activatePaymentNoticeV2
    # And paymentAmount with 400 in paGetPayment
    # And transfer.transferAmount with 200 in paGetPayment
    #     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    #     # Then check outcome is OK of activatePaymentNoticeV2 response
    #     And wait 30 seconds for expiration
    #     # verify fees retry in RE table
    #     # And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
    #     And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    #     And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    #     And checks the value PO of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    #     And checks the value ANY of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    #     And checks the value None of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    #     And checks the value None of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    #     And checks the value None of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    #     And checks the value None of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1


    # sendPaymentOutcome - sunny day
    Scenario: Execute activate 10
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

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