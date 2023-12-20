Feature: process DoppiaACT_PA OLD

    Background:
        Given systems up

    Scenario: Initial activatePaymentNotice request
        Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr_old# and application code NA
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>$1noticeNumber</noticeNumber>
            </qrCode>
            <amount>8.00</amount>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        Then saving activatePaymentNotice request in activatePaymentNotice1


    Scenario: Initial activatePaymentNotice2 request
        Given the Initial activatePaymentNotice request scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
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

    @runnable @pippoalf
    Scenario: parallel calls and test scenario
        Given the Initial activatePaymentNotice2 request scenario executed successfully
        And calling primitive activatePaymentNotice_activatePaymentNotice1 POST and activatePaymentNotice_activatePaymentNotice2 POST in parallel
        Then check primitive response activatePaymentNotice1Response and primitive response activatePaymentNotice2Response