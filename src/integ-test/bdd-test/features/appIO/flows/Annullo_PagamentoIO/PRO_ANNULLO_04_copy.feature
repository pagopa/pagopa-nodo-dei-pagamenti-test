Feature: PRO_ANNULLO_04

    Background:
        Given systems up

    Scenario: Execute verifyPaymentNotice request
        Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber  
        And initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:verifyPaymentNoticeReq>
                    <idPSP>#psp_AGID#</idPSP>
                    <idBrokerPSP>#broker_AGID#</idBrokerPSP>
                    <idChannel>#canale_AGID#</idChannel>
                    <password>pwdpwdpwd</password>
                    <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>$1noticeNumber</noticeNumber>
                    </qrCode>
                    </nod:verifyPaymentNoticeReq>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC new version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: Execute activateIOPayment request
        Given the Execute verifyPaymentNotice request scenario executed successfully
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activateIOPaymentReq>
                    <idPSP>#psp_AGID#</idPSP>
                    <idBrokerPSP>#broker_AGID#</idBrokerPSP>
                    <idChannel>#canale_AGID#</idChannel>
                    <password>pwdpwdpwd</password>
                    <!--Optional:-->
                    <idempotencyKey>#idempotency_key#</idempotencyKey>
                    <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>$1noticeNumber</noticeNumber>
                    </qrCode>
                    <!--Optional:-->
                    <expirationTime>6000</expirationTime>
                    <amount>10.00</amount>
                    <!--Optional:-->
                    <dueDate>2021-12-12</dueDate>
                    <!--Optional:-->
                    <paymentNote>responseFull</paymentNote>
                    <!--Optional:-->
                    <payer>
                        <uniqueIdentifier>
                        <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                        <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
                        </uniqueIdentifier>
                        <fullName>#idempotency_key_IOname#</fullName>
                        <!--Optional:-->
                        <streetName>IOstreet</streetName>
                        <!--Optional:-->
                        <civicNumber>IOcivic</civicNumber>
                        <!--Optional:-->
                        <postalCode>IOcode</postalCode>
                        <!--Optional:-->
                        <city>IOcity</city>
                        <!--Optional:-->
                        <stateProvinceRegion>IOstate</stateProvinceRegion>
                        <!--Optional:-->
                        <country>IT</country>
                        <!--Optional:-->
                        <e-mail>IO.test.prova@gmail.com</e-mail>
                    </payer>
                </nod:activateIOPaymentReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
                <soapenv:Header />
                <soapenv:Body>
                    <paf:paGetPaymentRes>
                        <outcome>OK</outcome>
                        <data>
                            <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
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
                            <country>IT</country>
                            <!--Optional:-->
                            <e-mail>IO.test.prova@gmail.com</e-mail>
                            </debtor>
                            <!--Optional:-->
                            <transferList>
                                <!--1 to 5 repetitions:-->
                                <transfer>
                                    <idTransfer>1</idTransfer>
                                    <transferAmount>10.00</transferAmount>
                                    <fiscalCodePA>$verifyPaymentNotice.fiscalCode</fiscalCodePA>
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
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response


    Scenario: Execute nodoChiediInformazioniPagamento request
        Given the Execute activateIOPayment request scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti      
        Then verify the HTTP status code of informazioniPagamento response is 200


    Scenario: initial primitive request
        Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:psp="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <psp:pspNotifyPaymentRes>
            <outcome>OK</outcome>
            <delay>10000</delay>
            </psp:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
                    """
            {
            "idPagamento":"$activateIOPaymentResponse.paymentToken",
            "RRN":18199444,
            "identificativoPsp":"#psp#",
            "tipoVersamento":"CP",
            "identificativoIntermediario":"#psp#",
            "identificativoCanale":"#canale#",
            "importoTotalePagato":10.00,
            "timestampOperazione":"2021-07-09T17:06:03.100+01:00",
            "codiceAutorizzativo":"resTim",
            "esitoTransazioneCarta":"00"
            }
            """

        And job mod3CancelV2 triggered after 10 seconds
        And wait 20 seconds for expiration
        Then verify the HTTP status code of inoltroEsito/carta response is 408
        And check error is Operazione in timeout of inoltroEsito/carta response
        And wait 15 seconds for expiration

        And checks the value PAYING, PAYMENT_SENT, PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        And restore initial configurations