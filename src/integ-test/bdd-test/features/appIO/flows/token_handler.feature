Feature: Token handler

    Background:
        Given systems up
        And EC old version
    # RICEVUTA_PM = 'Y'
    # FLAG = Y

    # verifyPaymentNotice phase
    Scenario: verifyPaymentNotice phase
        Given initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>AGID_01</idPSP>
            <idBrokerPSP>97735020584</idBrokerPSP>
            <idChannel>97735020584_03</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>44444444444</fiscalCode>
            <noticeNumber>311018771030140200</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When IO sends verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    # activateIOPayment phase
    Scenario: activateIOPayment phase
        Given the verifyPaymentNotice phase scenario request executed successfully
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activateIOPaymentReq>
            <idPSP>AGID_01</idPSP>
            <idBrokerPSP>97735020584</idBrokerPSP>
            <idChannel>97735020584_03</idChannel>
            <password>pwdpwdpwd</password>
            <!--Optional:-->
            <idempotencyKey>40000000001_115834xTlS</idempotencyKey>
            <qrCode>
            <fiscalCode>44444444444</fiscalCode>
            <noticeNumber>311018771030140200</noticeNumber>
            </qrCode>
            <!--Optional:-->
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <!--Optional:-->
            <!--dueDate>2021-12-12</dueDate-->
            <!--Optional:-->
            <paymentNote>responseFull</paymentNote>
            <!--Optional:-->

            </nod:activateIOPaymentReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When IO sends activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    # nodoInoltraEsitoPagamentoCarta
    Scenario: nodoInoltraEsitoPagamentoCarta
        When IO sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "2d6a54714c72499eb71115d606152632",
                "RRN": 18865881,
                "identificativoPsp": "40000000001",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "40000000001",
                "identificativoCanale": "40000000001_03",
                "importoTotalePagato": 10,
                "timestampOperazione": "2021-07-09T17:06:03.100+01:00",
                "codiceAutorizzativo": "resOK",
                "esitoTransazioneCarta": "00"
            }
            """
        Then verify the HTTP status code of nodoInoltraEsitoPagamentoCarta response is 200



    # [GT_01]
    Scenario: GT_01
        Given the activateIOPayment phase request scenario executed successfully
        And check if is present a record in IDEMPOTENCY_CACHE table
        And the nodoChiediInformazioniPagamento request scenario executed successfully
        When IO sends rest GET informazioniPagamento?idPagamento=ea6f7c01f729467a9d50793113faa3cb to nodo-dei-pagamenti
        Then verify the HTTP status code of nodoChiediInformazioniPagamento response is 200
        And check if is not present a record in IDEMPOTENCY_CACHE table
        And check if is present a value in TOKEN_VALID_FROM column in POSITION_ACTIVATE table
        And check if is present a value in TOKEN_VALID_TO column in POSITION_ACTIVATE TABLE

    # [GT_02]
    Scenario: GT_02
    

