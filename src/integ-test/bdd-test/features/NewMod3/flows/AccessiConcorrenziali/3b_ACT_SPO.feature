Feature: process tests for accessiConCorrenziali [3b_ACT_SPO]

    Background:
        Given systems up
        And EC old version

    # 3b_ACT_SPO
    Scenario: Execute activatePaymentNotice request
        Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr_old# and application code NA
        And generate 1 cart with PA #creditor_institution_code_old# and notice number $1noticeNumber  
        And initial XML activatePaymentNotice
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header />
        <soapenv:Body>
        <nod:activatePaymentNoticeReq>
        <idPSP>#psp#</idPSP>
        <idBrokerPSP>#psp#</idBrokerPSP>
        <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
        <password>pwdpwdpwd</password>
        <idempotencyKey>#idempotency_key#</idempotencyKey>
        <qrCode>
        <fiscalCode>#creditor_institution_code_old#</fiscalCode>
        <noticeNumber>$1noticeNumber</noticeNumber>
        </qrCode>
        <expirationTime>2000</expirationTime>
        <amount>10.00</amount>
        </nod:activatePaymentNoticeReq>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice1

    Scenario: trigger poller annulli
        Given the Execute activatePaymentNotice request scenario executed successfully
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200


    Scenario: Execute second activatePaymentNotice request
        Given the trigger poller annulli scenario executed successfully
        And initial XML activatePaymentNotice
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header />
        <soapenv:Body>
        <nod:activatePaymentNoticeReq>
        <idPSP>#psp#</idPSP>
        <idBrokerPSP>#psp#</idBrokerPSP>
        <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
        <password>pwdpwdpwd</password>
        <idempotencyKey>#idempotency_key#</idempotencyKey>
        <qrCode>
        <fiscalCode>#creditor_institution_code_old#</fiscalCode>
        <noticeNumber>$1noticeNumber</noticeNumber>
        </qrCode>
        <amount>8.00</amount>
        </nod:activatePaymentNoticeReq>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        Then saving activatePaymentNotice request in activatePaymentNotice2

    Scenario: Excecute sendPaymentOutcome request
        Given the Execute second activatePaymentNotice request scenario executed successfully
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <paymentToken>$activatePaymentNotice1Response.paymentToken</paymentToken>
            <outcome>KO</outcome>
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
            <entityUniqueIdentifierValue>#creditor_institution_code_old#</entityUniqueIdentifierValue>
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
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        Then saving sendPaymentOutcome request in sendPaymentOutcome1

    @runnable @lazy
    Scenario: parallel calls and test scenario
        Given the Excecute sendPaymentOutcome request scenario executed successfully
        And calling primitive activatePaymentNotice_activatePaymentNotice2 POST and sendPaymentOutcome_sendPaymentOutcome1 POST in parallel
        Then check primitive response activatePaymentNotice2Response and primitive response sendPaymentOutcome1Response