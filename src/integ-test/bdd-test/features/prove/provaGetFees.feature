Feature: prova getFees

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
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>44444444444</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest2</transferCategory>
            </transfer>
            </transferList>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

    @skip
    # sunny day
    Scenario: Execute activate 1
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.touchPoint of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2Response.suggestedIdBundle of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2Response.suggestedIdCiBundle of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2Response.suggestedUserFee of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2Response.suggestedPaFee of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # activate without paymentMethod and touchPoint
    Scenario: Execute activate 2
        Given the activatePaymentNoticeV2 scenario executed successfully
        And paymentMethod with None in activatePaymentNoticeV2
        And touchPoint with None in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 30 seconds for expiration
        And verify 2 record for the table RE retrived by the query select_fees on db re under macro getFees
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value ANY of the record at column PAYMENT_METHOD of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PSP of the record at column TOUCHPOINT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
# And checks the value $activatePaymentNoticeV2Response.suggestedIdBundle of the record at column SUGGESTED_IDBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
# And checks the value $activatePaymentNoticeV2Response.suggestedIdCiBundle of the record at column SUGGESTED_IDCIBUNDLE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
# And checks the value $activatePaymentNoticeV2Response.suggestedUserFee of the record at column SUGGESTED_USER_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
# And checks the value $activatePaymentNoticeV2Response.suggestedPaFee of the record at column SUGGESTED_PA_FEE of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1