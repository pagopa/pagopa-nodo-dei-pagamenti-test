Feature: Check codifica bar code- OK

    #################################################################################
    #                                                                               #
    #              CERCARE UN MODO PER FARE IL TUTTO CON SCENARIO OUTLINE           #
    #                                                                               #
    #################################################################################

    Background:
        Given systems up
        And EC old version

        Given initial XML verifyRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoVerificaRPT>
            <identificativoPSP>40000000001</identificativoPSP>
            <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
            <identificativoCanale>40000000001_01</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>129311663116240</codiceContestoPagamento>
            <codificaInfrastrutturaPSP>BARCODE-GS1-128</codificaInfrastrutturaPSP>
            <codiceIdRPT><bc:BarCode>  <bc:Gln>4444444444444</bc:Gln>  <bc:CodStazPA>02</bc:CodStazPA>  <bc:AuxDigit>0</bc:AuxDigit>  <bc:CodIUV>139071058514448</bc:CodIUV> </bc:BarCode></codiceIdRPT>
            </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        Given initial XML activateRPT
            """

            """

        Given initial XML sendRPT
            """

            """

        Given initial XML sendRT
            """

            """

    # [FLUSSO_OK_barCode_GS1_aux0]
    Scenario: verifyRPT phase
        Given bc:AuxDigit with 0 in verifyRPT
        When PSP sends soap verifyRPT to nodo-dei-pagamenti
        Then check esito is OK of verifyRPT response

    Scenario: activateRPT phase
        Given the verifyRPT phase scenario request executed successfully
        And bc:AuxDigit with 0 in activateRPT
        When PSP sends soap activateRPT to nodo-dei-pagamenti
        Then check esito is OK of activateRPT

    Scenario: sendRPT phase
        Given the activateRPT phase scenario request executed successfully
        When PSP sends SOAP sendRPT to nodo-dei-pagamenti
        Then check esito is OK of sendRPT response

    Scenario: sendRT phase
        Given the sendRPT phase scenario request executed successfully
        When PSP sends SOAP sendRT to nodo-dei-pagamenti
        Then check esito is OK of sendRT response
        And TODO: FARE PARTE DB


    # [FLUSSO_OK_barCode_GS1_aux1]
    Scenario: bcCode_aux1
        Given bc:AuxDigit with 1 in verifyRPT
        When PSP sends verifyRPT to nodo-dei-pagamenti
        Then check esito is OK of verifyRPT response

    Scenario: activateRPT phase
        Given the verifyRPT phase scenario request executed successfully
        And bc:AuxDigit with 1 in activateRPT
        When PSP sends activateRPT to nodo-dei-pagamenti
        Then check esito is OK of activateRPT

    Scenario: sendRPT phase
        Given the activateRPT phase scenario request executed successfully
        When PSP sends SOAP sendRPT to nodo-dei-pagamenti
        Then check esito is OK of sendRPT response

    Scenario: sendRT phase
        Given the sendRPT phase scenario request executed successfully
        When PSP sends SOAP sendRT to nodo-dei-pagamenti
        Then check esito is OK of sendRT response
        And TODO: FARE PARTE DB

    # [FLUSSO_OK_barCode_GS1_aux2]
    Scenario: bcCode_aux2
        Given bc:AuxDigit with 2 in verifyRPT
        When PSP sends verify to nodo-dei-pagamenti
        Then check esito is OK of verifyRPT

    Scenario: activateRPT phase
        Given the verifyRPT phase scenario request executed successfully
        And bc:AuxDigit with 2 in activateRPT
        When PSP sends activateRPT to nodo-dei-pagamenti
        Then check esito is OK of activateRPT

    Scenario: sendRPT phase
        Given the activateRPT phase scenario request executed successfully
        When PSP sends SOAP sendRPT to nodo-dei-pagamenti
        Then check esito is OK of sendRPT response

    Scenario: sendRT phase
        Given the sendRPT phase scenario request executed successfully
        When PSP sends SOAP sendRT to nodo-dei-pagamenti
        Then check esito is OK of sendRT response
        And TODO: FARE PARTE DB

    # [FLUSSO_OK_barCode_GS1_aux3]
    Scenario: bcCode_aux3
        Given bc:AuxDigit with 3 in verifyRPT
        When PSP sends verify to nodo-dei-pagamenti
        Then check esito is OK of verifyRPT response

    Scenario: activateRPT phase
        Given the verifyRPT phase scenario request executed successfully
        And bc:AuxDigit with 3 in activateRPT
        When PSP sends activateRPT to nodo-dei-pagamenti
        Then check esito is OK of activateRPT

    Scenario: sendRPT phase
        Given the activateRPT phase scenario request executed successfully
        When PSP sends SOAP sendRPT to nodo-dei-pagamenti
        Then check esito is OK of sendRPT response

    Scenario: sendRT phase
        Given the sendRPT phase scenario request executed successfully
        When PSP sends SOAP sendRT to nodo-dei-pagamenti
        Then check esito is OK of sendRT response
        And TODO: FARE PARTE DB