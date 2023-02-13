# Il test verifica che la paSendRTV2 sia inviata correttamente in caso di 3 transfers con 3 marche da bollo a tutti i recipient in caso di broadcast = true

Feature: flow tests for paSendRTV2 - Marca da bollo
    # Reference document:
    # https://pagopa.atlassian.net/wiki/spaces/PAG/pages/527138945/Analisi+paSendRTV2
    # https://pagopa.atlassian.net/wiki/spaces/PAG/pages/558204362/WIP+A.T.+Gestione+della+marca+da+bollo+digitale+nel+NMU#paSendRTV2
    # https://pagopa.atlassian.net/wiki/spaces/PAG/pages/540967264/PAG-1826+-+Gestione+Marca+da+Bollo+nel+NMU

    Background:
        Given systems up

    #DB update
    Scenario: Execute station update
        Then updates through the query stationUpdateVersione of the table STAZIONI the parameter VERSIONE_PRIMITIVE with 2 under macro sendPaymentResultV2 on db nodo_cfg
        And updates through the query stationUpdateBroadcast of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro sendPaymentResultV2 on db nodo_cfg

    #refresh pa e stazioni
    Scenario: Execute refresh pa e stazioni
        Given the Execute station update scenario executed successfully
        Then refresh job PA triggered after 10 seconds

    Scenario: Execute activatePaymentNoticeV2
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#pspEcommerce#</idPSP>
            <idBrokerPSP>#brokerEcommerce#</idBrokerPSP>
            <idChannel>#canaleEcommerce#</idChannel>
            <password>#password#</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
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
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
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
            <country>IT</country>
            <!--Optional:-->
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>2.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <richiestaMarcaDaBollo>
            <hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</hashDocumento>
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
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
            <richiestaMarcaDaBollo>
            <hashDocumento>ciao</hashDocumento>
            <tipoBollo>01</tipoBollo>
            <provinciaResidenza>MI</provinciaResidenza>
            </richiestaMarcaDaBollo>
            <remittanceInformation>information2</remittanceInformation>
            <transferCategory>category2</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>90000000002</fiscalCodePA>
            <richiestaMarcaDaBollo>
            <hashDocumento>ciao</hashDocumento>
            <tipoBollo>01</tipoBollo>
            <provinciaResidenza>MI</provinciaResidenza>
            </richiestaMarcaDaBollo>
            <remittanceInformation>information3</remittanceInformation>
            <transferCategory>category3</transferCategory>
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
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

    # define closePaymentV2
    Scenario: closePaymentV2
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "token"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2012-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "12345678"
                },
                "additionalPMInfo": {
                    "origin": "",
                    "user": {
                        "fullName": "John Doe",
                        "type": "F",
                        "fiscalCode": "JHNDOE00A01F205N",
                        "notificationEmail": "john.doe@mail.it",
                        "userId": 1234,
                        "userStatus": 11,
                        "userStatusDescription": "REGISTERED_SPID"
                    }
                }
            }
            """

    # define MBD
    Scenario: Define MBD
        Given initial xml MB
            """
            <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
            <PSP>
            <CodiceFiscale>CF60000000006</CodiceFiscale>
            <Denominazione>#psp#</Denominazione>
            </PSP>
            <IUBD>#iubd#</IUBD>
            <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
            <Importo>5.00</Importo>
            <TipoBollo>01</TipoBollo>
            <ImprontaDocumento>
            <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
            <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
            </ImprontaDocumento>
            <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
            <SignedInfo>
            <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
            <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
            <Reference URI="">
            <Transforms>
            <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
            </Transforms>
            <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
            <DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</DigestValue>
            </Reference>
            </SignedInfo>
            <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
            </Signature>
            </marcaDaBollo>
            """

    # closePayment-v2 phase
    Scenario: Execute a closePayment-v2 request
        Given the Execute activatePaymentNoticeV2 scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And paymentToken with $activatePaymentNoticeV2Response.paymentToken in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then check outcome is OK of v2/closepayment response
        And verify the HTTP status code of v2/closepayment response is 200

    # sendPaymentOutcome phase
    Scenario: Execute sendPaymentOutcomeV2
        Given the Define MBD scenario executed successfully
        And MB generation
            """
            $MB
            """
        And the Execute a closePayment-v2 request scenario executed successfully
        And initial XML sendPaymentOutcomeV2
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
            <fee>2.00</fee>
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
            <marcheDaBollo>
            <marcaDaBollo>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            <idTransfer>1</idTransfer>
            <MBDAttachment>$bollo</MBDAttachment>
            </marcaDaBollo>
            <marcaDaBollo>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            <idTransfer>2</idTransfer>
            <MBDAttachment>PG1hcmNhRGFCb2xsbwogICAgeG1sbnM9Imh0dHA6Ly93d3cuYWdlbnppYWVudHJhdGUuZ292Lml0LzIwMTQvTWFyY2FEYUJvbGxvIgogICAgeG1sbnM6bnMyPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4KICAgIDxQU1A+CiAgICAgICAgPENvZGljZUZpc2NhbGU+Q0Y3MDAwMDAwMDAwMTwvQ29kaWNlRmlzY2FsZT4KICAgICAgICA8RGVub21pbmF6aW9uZT43MDAwMDAwMDAwMTwvRGVub21pbmF6aW9uZT4KICAgIDwvUFNQPgogICAgPElVQkQ+MTIzNDU2Nzg5MDEyMzQ1PC9JVUJEPgogICAgPE9yYUFjcXVpc3RvPjIwMjItMDItMDZUMTU6MDA6NDQuNjU5KzAxOjAwPC9PcmFBY3F1aXN0bz4KICAgIDxJbXBvcnRvPjUuMDA8L0ltcG9ydG8+CiAgICA8VGlwb0JvbGxvPjAxPC9UaXBvQm9sbG8+CiAgICA8SW1wcm9udGFEb2N1bWVudG8+CiAgICAgICAgPERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIgLz4KICAgICAgICA8bnMyOkRpZ2VzdFZhbHVlPmNpYW88L25zMjpEaWdlc3RWYWx1ZT4KICAgIDwvSW1wcm9udGFEb2N1bWVudG8+CiAgICA8U2lnbmF0dXJlCiAgICAgICAgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPgogICAgICAgIDxTaWduZWRJbmZvPgogICAgICAgICAgICA8Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1IiAvPgogICAgICAgICAgICA8U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxkc2lnLW1vcmUjcnNhLXNoYTI1NiIgLz4KICAgICAgICAgICAgPFJlZmVyZW5jZSBVUkk9IiI+CiAgICAgICAgICAgICAgICA8VHJhbnNmb3Jtcz4KICAgICAgICAgICAgICAgICAgICA8VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiIC8+CiAgICAgICAgICAgICAgICA8L1RyYW5zZm9ybXM+CiAgICAgICAgICAgICAgICA8RGlnZXN0TWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjc2hhMjU2IiAvPgogICAgICAgICAgICAgICAgPERpZ2VzdFZhbHVlPndIcEZTTENHWmpJdk5TWHhxdEdieGc3Mjc1dDQ0NkRSVGs1WnJzZFVRNkU9PC9EaWdlc3RWYWx1ZT4KICAgICAgICAgICAgPC9SZWZlcmVuY2U+CiAgICAgICAgPC9TaWduZWRJbmZvPgogICAgICAgIDxTaWduYXR1cmVWYWx1ZT50U081U0J5TnBhZGJ6YlB2VW41VDk5YWpVNGhIZHFKTFZ5cjR1OFA4V1NCNXhjOUs3U3ptdy9mbzVTWVhZYVBTNkEvRHpQbGNoTTk1IGZnRk1aM1ZZQnlxdEErVmM3V2dYOGFJT0VWT3JNNmVYcXg4K2tjNGcvamdtLzlFUXlVbVhHUCtSQnZ4MlNnMHVpbTA0YURkQjdGZmQgVUlpNlE1dmpqbmExcmhOdlpJa0JFakNWKytmK3diTDlxcEZMdDhFMk4rYk9xOVkwd2NUVUJIaUlDcnhYdkRCRFVqMVg3Q2tidTAvWSBLVlJKY2s2Y0U1cnBvUUI2RGp4ZEVuNURFVWdtelIvVVpFd3RBMUJLM2NWUmlPc2Fzeng4YlhFSXdHSGU0ZnZ2enhKT0hJcWdMNGN0IGpqMURvSTVtMnhHb29iUTNyRzZQZjNIRXdGWEx3OXg4M095a0RBPT08L1NpZ25hdHVyZVZhbHVlPgogICAgPC9TaWduYXR1cmU+CjwvbWFyY2FEYUJvbGxvPg==</MBDAttachment>
            </marcaDaBollo>
            <marcaDaBollo>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            <idTransfer>3</idTransfer>
            <MBDAttachment>PG1hcmNhRGFCb2xsbwogICAgeG1sbnM9Imh0dHA6Ly93d3cuYWdlbnppYWVudHJhdGUuZ292Lml0LzIwMTQvTWFyY2FEYUJvbGxvIgogICAgeG1sbnM6bnMyPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4KICAgIDxQU1A+CiAgICAgICAgPENvZGljZUZpc2NhbGU+Q0Y3MDAwMDAwMDAwMTwvQ29kaWNlRmlzY2FsZT4KICAgICAgICA8RGVub21pbmF6aW9uZT43MDAwMDAwMDAwMTwvRGVub21pbmF6aW9uZT4KICAgIDwvUFNQPgogICAgPElVQkQ+MTIzNDU2Nzg5MDEyMzQ1PC9JVUJEPgogICAgPE9yYUFjcXVpc3RvPjIwMjItMDItMDZUMTU6MDA6NDQuNjU5KzAxOjAwPC9PcmFBY3F1aXN0bz4KICAgIDxJbXBvcnRvPjUuMDA8L0ltcG9ydG8+CiAgICA8VGlwb0JvbGxvPjAxPC9UaXBvQm9sbG8+CiAgICA8SW1wcm9udGFEb2N1bWVudG8+CiAgICAgICAgPERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIgLz4KICAgICAgICA8bnMyOkRpZ2VzdFZhbHVlPmNpYW88L25zMjpEaWdlc3RWYWx1ZT4KICAgIDwvSW1wcm9udGFEb2N1bWVudG8+CiAgICA8U2lnbmF0dXJlCiAgICAgICAgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPgogICAgICAgIDxTaWduZWRJbmZvPgogICAgICAgICAgICA8Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1IiAvPgogICAgICAgICAgICA8U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxkc2lnLW1vcmUjcnNhLXNoYTI1NiIgLz4KICAgICAgICAgICAgPFJlZmVyZW5jZSBVUkk9IiI+CiAgICAgICAgICAgICAgICA8VHJhbnNmb3Jtcz4KICAgICAgICAgICAgICAgICAgICA8VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiIC8+CiAgICAgICAgICAgICAgICA8L1RyYW5zZm9ybXM+CiAgICAgICAgICAgICAgICA8RGlnZXN0TWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjc2hhMjU2IiAvPgogICAgICAgICAgICAgICAgPERpZ2VzdFZhbHVlPndIcEZTTENHWmpJdk5TWHhxdEdieGc3Mjc1dDQ0NkRSVGs1WnJzZFVRNkU9PC9EaWdlc3RWYWx1ZT4KICAgICAgICAgICAgPC9SZWZlcmVuY2U+CiAgICAgICAgPC9TaWduZWRJbmZvPgogICAgICAgIDxTaWduYXR1cmVWYWx1ZT50U081U0J5TnBhZGJ6YlB2VW41VDk5YWpVNGhIZHFKTFZ5cjR1OFA4V1NCNXhjOUs3U3ptdy9mbzVTWVhZYVBTNkEvRHpQbGNoTTk1IGZnRk1aM1ZZQnlxdEErVmM3V2dYOGFJT0VWT3JNNmVYcXg4K2tjNGcvamdtLzlFUXlVbVhHUCtSQnZ4MlNnMHVpbTA0YURkQjdGZmQgVUlpNlE1dmpqbmExcmhOdlpJa0JFakNWKytmK3diTDlxcEZMdDhFMk4rYk9xOVkwd2NUVUJIaUlDcnhYdkRCRFVqMVg3Q2tidTAvWSBLVlJKY2s2Y0U1cnBvUUI2RGp4ZEVuNURFVWdtelIvVVpFd3RBMUJLM2NWUmlPc2Fzeng4YlhFSXdHSGU0ZnZ2enhKT0hJcWdMNGN0IGpqMURvSTVtMnhHb29iUTNyRzZQZjNIRXdGWEx3OXg4M095a0RBPT08L1NpZ25hdHVyZVZhbHVlPgogICAgPC9TaWduYXR1cmU+CjwvbWFyY2FEYUJvbGxvPg==</MBDAttachment>
            </marcaDaBollo>
            </marcheDaBollo>
            </details>
            </nod:sendPaymentOutcomeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And wait 5 seconds for expiration
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response


    @test
    # DB check
    Scenario: execute DB check
        Given the Execute sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query stationUpdateBroadcast of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro sendPaymentResultV2 on db nodo_cfg
        Then refresh job PA triggered after 10 seconds
        # POSITION_TRANSFER_MBD
        Then verify 3 record for the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value $MB.TipoBollo of the record at column TIPO_BOLLO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value BD of the record at column TIPO_ALLEGATO_RICEVUTA of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value $iubd of the record at column IUBD of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value $MB.Importo of the record at column IMPORTO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ORA_ACQUISTO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column INSERTED_BY of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
        # POSITION_TRANSFER
        And verify 3 record for the table POSITION_TRANSFER retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value None of the record at column IBAN of the table POSITION_TRANSFER retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value 01 of the record at column REQ_TIPO_BOLLO of the table POSITION_TRANSFER retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= of the record at column REQ_HASH_DOCUMENTO of the table POSITION_TRANSFER retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value MI of the record at column REQ_PROVINCIA_RESIDENZA of the table POSITION_TRANSFER retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value None of the record at column IBAN of the table POSITION_TRANSFER retrived by the query position_receipt_recipient_v2_desc on db nodo_online under macro sendPaymentResultV2
        And checks the value 01 of the record at column REQ_TIPO_BOLLO of the table POSITION_TRANSFER retrived by the query position_receipt_recipient_v2_desc on db nodo_online under macro sendPaymentResultV2
        And checks the value ciao of the record at column REQ_HASH_DOCUMENTO of the table POSITION_TRANSFER retrived by the query position_receipt_recipient_v2_desc on db nodo_online under macro sendPaymentResultV2
        And checks the value MI of the record at column REQ_PROVINCIA_RESIDENZA of the table POSITION_TRANSFER retrived by the query position_receipt_recipient_v2_desc on db nodo_online under macro sendPaymentResultV2
        # RE
        And verify 6 record for the table RE retrived by the query select_paSendRTV2 on db re under macro sendPaymentResultV2
        And checks the value REQ,RESP,REQ,RESP,REQ,RESP of the record at column SOTTO_TIPO_EVENTO of the table RE retrived by the query select_paSendRTV2 on db re under macro sendPaymentResultV2
        And checks the value 66666666666_08,66666666666_08,90000000001_06,90000000001_06,90000000001_01,90000000001_01 of the record at column EROGATORE_DESCR of the table RE retrived by the query select_paSendRTV2 on db re under macro sendPaymentResultV2
        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 9 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_RETRY_PA_SEND_RT
        And verify 0 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        # POSITION_RECEIPT_RECIPIENT
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value 66666666666,90000000001,90000000002 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value 66666666666,90000000001,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value 66666666666_08,90000000001_06,90000000001_01 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2
        And checks the value NOTIFIED,NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_receipt_recipient_v2 on db nodo_online under macro sendPaymentResultV2

# inserire i check sul blob in RE per l'xml paSendRTV2