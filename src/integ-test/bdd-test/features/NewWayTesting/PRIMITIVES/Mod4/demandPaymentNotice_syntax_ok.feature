Feature: flow tests for demandPaymentNotice 923

    #Questi test per ora non funzionano, dovrebbe essere il PG-106 e funzioneranno solo dopo il merge. Attualmente questa implementazione non è ancora su postgres (23/08/24)

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM4
    Scenario: demandPaymentNotice
        Given initial XML demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idSoggettoServizio>00042</idSoggettoServizio>
            <datiSpecificiServizio>Y2lhbyBjYXJv</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paDemandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
            <outcome>OK</outcome>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
            <paymentList>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <paymentDescription>paymentDescription</paymentDescription>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <companyName>companyName</companyName>
            <officeName>officeName</officeName>
            </paf:paDemandPaymentNoticeResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends soap demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response



    @ALL @PRIMITIVE @NM4
    Scenario: demandPaymentNotice
        Given initial XML demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idSoggettoServizio>00041</idSoggettoServizio>
            <datiSpecificiServizio>PGNpYW8+Y2FybzwvY2lhbz4=</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paDemandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
            <outcome>OK</outcome>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
            <paymentList>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <paymentDescription>paymentDescription</paymentDescription>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <companyName>companyName</companyName>
            <officeName>officeName</officeName>
            </paf:paDemandPaymentNoticeResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends soap demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response