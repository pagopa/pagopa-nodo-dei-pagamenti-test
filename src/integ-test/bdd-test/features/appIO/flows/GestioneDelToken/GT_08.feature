Feature: GT_08 61

    Background:
        Given systems up
        

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given nodo-dei-pagamenti has config parameter useIdempotency set to true
        And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 6000
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 6000
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
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
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: Execute activateIOPayment (Phase 2)
        Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-07-31</dueDate>
            <description>TARI 2021</description>
            <companyName>company PA</companyName>
            <officeName>office PA</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>John Doe</fullName>
            <streetName>street</streetName>
            <civicNumber>12</civicNumber>
            <postalCode>89020</postalCode>
            <city>city</city>
            <stateProvinceRegion>MI</stateProvinceRegion>
            <country>IT</country>
            <e-mail>john.doe@test.it</e-mail>
            </debtor>
            <transferList>
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT96R0123454321000000012345</IBAN>
            <remittanceInformation>TARI Comune EC_TE</remittanceInformation>
            <transferCategory>0101101IM</transferCategory>
            </transfer>
            </transferList>
            </data>
            </paf:paGetPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activateIOPaymentReq>
            <idPSP>$verifyPaymentNotice.idPSP</idPSP>
            <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
            <idChannel>$verifyPaymentNotice.idChannel</idChannel>
            <password>$verifyPaymentNotice.password</password>
            <!--Optional:-->
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
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
            <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>civic</civicNumber>
            <!--Optional:-->
            <postalCode>code</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>test.prova@gmail.com</e-mail>
            </payer>
            </nod:activateIOPaymentReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value activateIOPayment of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        #And check token_valid_to is equal to token_valid_from plus default_durata_token_IO


    Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO

    Scenario: Execute nodoInoltraEsitoPagamentoCarta (Phase 4)
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
            <outcome>Response malformata</outcome>
            </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$activateIOPaymentResponse.paymentToken",
                "RRN": 18865881,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "importoTotalePagato": 10,
                "timestampOperazione": "2021-07-09T17:06:03.100+01:00",
                "codiceAutorizzativo": "resOK",
                "esitoTransazioneCarta": "00"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 408
        And check error is Operazione in timeout of inoltroEsito/carta response

    Scenario: Execute sendPaymentOutcome (Phase 5)
        Given the Execute nodoInoltraEsitoPagamentoCarta (Phase 4) scenario executed successfully
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
            <outcome>OK</outcome>
            <!--Optional:-->
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>SPOname_$activateIOPaymentResponse.paymentToken</fullName>
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
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When job mod3CancelV2 triggered after 15 seconds
        And wait 10 seconds for expiration
        And PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And apply new restore initial configurations
    @PM
    Scenario: activateIOPayment1
        Given the Execute sendPaymentOutcome (Phase 5) scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response