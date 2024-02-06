Feature: activateIO with old notice number retrieved from DB

    Background:
        Given systems up

    Scenario: Execute verifyPaymentNotice with old notice number retrieved from DB
        Given execution query select_noticeGroup to get value on the table POSITION_SERVICE, with the columns ppp.NOTICE_ID, ppp.CREDITOR_REFERENCE_ID, ppp.DUE_DATE, ppp.AMOUNT, ppp.FK_POSITION_SERVICE, ps.DESCRIPTION, ps.COMPANY_NAME, ps.OFFICE_NAME under macro costanti with db name nodo_online
        And through the query select_noticeGroup retrieve valid noticeID from POSITION_PAYMENT_PLAN on db nodo_online
        And retrieve param noticeID at position 0 and save it under the key noticeID through the query select_noticeGroup
        And retrieve param creditorID at position 1 and save it under the key creditorID through the query select_noticeGroup
        And retrieve param dueDate at position 2 and save it under the key dueDate through the query select_noticeGroup
        And retrieve param amount at position 3 and save it under the key amount through the query select_noticeGroup
        And retrieve param description at position 5 and save it under the key description through the query select_noticeGroup
        And retrieve param companyName at position 6 and save it under the key companyName through the query select_noticeGroup
        And retrieve param officeName at position 7 and save it under the key officeName through the query select_noticeGroup
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
            <noticeNumber>$noticeID</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    # Il test verifica che, preso un vecchio noticeID a DB in stato INSERTED (a seguito di un mod3cancel) e con un PLAN inserito da più di una settimana,
    # l'activate riutilizzi lo stesso PLAN (cioè verifichi tutti i dati sul DB inerenti a questo noticeID) 

    @appIO @ALL @bugFix
    Scenario: Execute activateIOPayment with old notice number retrieved from DB
        Given the Execute verifyPaymentNotice with old notice number retrieved from DB scenario executed successfully
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
            <noticeNumber>$noticeID</noticeNumber>
            </qrCode>
            <!--Optional:-->
            <expirationTime>60000</expirationTime>
            <amount>$amount</amount>
            <!--Optional:-->
            <dueDate>$dueDate</dueDate>
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
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>$creditorID</creditorReferenceId>
            <paymentAmount>$amount</paymentAmount>
            <dueDate>$dueDate</dueDate>
            <description>$description</description>
            <companyName>$companyName</companyName>
            <officeName>$officeName</officeName>
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
            <metadata>
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
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

