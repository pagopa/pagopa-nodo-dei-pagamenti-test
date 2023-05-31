Feature: Pag-1163_Paypal_NCAP_Setup

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

    @runnable @dependentread
    Scenario: Execute nodoChiediInformazioniPagamento request
        Given the Execute activateIOPayment request scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti      
        Then verify the HTTP status code of informazioniPagamento response is 200
        And check importo field exists in informazioniPagamento response
        And check ragioneSociale field exists in informazioniPagamento response
        And check oggettoPagamento field exists in informazioniPagamento response
        And check urlRedirectEC field exists in informazioniPagamento response
        And check bolloDigitale is False of informazioniPagamento response
        And check email is IO.test.prova@gmail.com of informazioniPagamento response
        And check dettagli field exists in informazioniPagamento response
        And check idDominio is $verifyPaymentNotice.fiscalCode of informazioniPagamento response
        And check enteBeneficiario field exists in informazioniPagamento response
        And execution query dbcheck_json to get value on the table PA, with the columns RAGIONE_SOCIALE under macro NewMod3 with db name nodo_cfg
        And through the query dbcheck_json retrieve param ragione_sociale at position 0 and save it under the key ragione_sociale
        And check enteBeneficiario is $ragione_sociale of informazioniPagamento response
        And check ragioneSociale is $ragione_sociale of informazioniPagamento response
