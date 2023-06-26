Feature: process tests for TF_POSTE_04

    Background:
        Given systems up
        And initial XML paVerifyPaymentNotice
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
        <soapenv:Header />
        <soapenv:Body>
        <paf:paVerifyPaymentNoticeRes>
        <outcome>OK</outcome>
        <paymentList>
        <paymentOptionDescription>
        <amount>10.00</amount>
        <options>EQ</options>
        <dueDate>2021-07-31</dueDate>
        <detailDescription>pagamentoTest</detailDescription>
        <allCCP>false</allCCP>
        </paymentOptionDescription>
        </paymentList>
        <paymentDescription>Pagamento di Test</paymentDescription>
        <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
        <companyName>companyName</companyName>
        <officeName>officeName</officeName>
        </paf:paVerifyPaymentNoticeRes>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML verificaBollettino
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:verificaBollettinoReq>
                    <idPSP>#pspPoste#</idPSP>
                    <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
                    <idChannel>#channelPoste#</idChannel>
                    <password>pwdpwdpwd</password>
                    <ccPost>#ccPoste#</ccPost>
                    <noticeNumber>#notice_number#</noticeNumber>
                </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC new version

    # Verify phase
    Scenario: Execute verificaBollettino request
        Given EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        And verify 0 record for the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3

    @runnable @dependentwrite
    Scenario: Execute activatePaymentNotice request
        Given the Execute verificaBollettino request scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activatePaymentNoticeReq>
                    <idPSP>#pspPoste#</idPSP>
                    <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
                    <idChannel>#channelPoste#</idChannel>
                    <password>pwdpwdpwd</password>
                    <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>$verificaBollettino.noticeNumber</noticeNumber>
                    </qrCode>
                    <amount>10.00</amount>
                </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
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
            <fiscalCodePA>77777777777</fiscalCodePA>
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
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And checks the value IT45R0760103200000000001016 of the record at column IBAN of the table POSITION_TRANSFER retrived by the query position_transfer on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
