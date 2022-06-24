Feature: process tests for TF_POSTE_04

    Background:
        Given systems up
        And initial XML verificaBollettino
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verificaBollettinoReq>
            <idPSP>POSTE3</idPSP>
            <idBrokerPSP>BANCOPOSTA</idBrokerPSP>
            <idChannel>POSTE3</idChannel>
            <password>pwdpwdpwd</password>
            <ccPost>444444444444</ccPost>
            <noticeNumber>311011121646144200</noticeNumber>
            </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC new version

    # Verify phase
    Scenario: Execute verificaBollettino request
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is KO of verificaBollettino response
        And checkS the value None of the record at column ID OF the table POSITION_TRANSFER retrived by the query position_transfer_TF_POSTE_04_1 on db nodo_online under macro NewMod3




    Scenario: Execute activatePaymentNotice request
        Given the Execute verificaBollettino request scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nfpsp="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd" xmlns:tns="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.wsdl">
            <soapenv:Body>
            <nfpsp:activatePaymentNoticeRes>
            <outcome>OK</outcome>
            <totalAmount>10.00</totalAmount>
            <paymentDescription>test</paymentDescription>
            <fiscalCodePA>44444444444</fiscalCodePA>
            <companyName>company</companyName>
            <officeName>office</officeName>
            <paymentToken>2806a17f3ccd477c80a008672ac69696</paymentToken>
            <transferList>
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>44444444444</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            </transfer>
            </transferList>
            <creditorReferenceId>11016111543194300</creditorReferenceId>
            </nfpsp:activatePaymentNoticeRes>
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
        And checks the value $paGetPayment.IBAN of the record at column IBAN of the table POSITION_TRANSFER retrived by the query position_transfer_TF_POSTE_04_2 on db nodo_online under macro NewMod3
