Feature: Semantic checks for verificaBollettino - OK 1396

    Background:
        Given systems up
        And EC old version
    @runnable
    Scenario: Execute verificaBollttino [SEM_VB_10]
        Given initial XML verificaBollettino
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verificaBollettinoReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <ccPost>#ccPoste#</ccPost>
            <noticeNumber>#notice_number_old#</noticeNumber>
            </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
