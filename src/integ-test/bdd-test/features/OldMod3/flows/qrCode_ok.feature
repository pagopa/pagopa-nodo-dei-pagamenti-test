Feature: Check codifica QR code - OK

    #################################################################################
    #                                                                               #
    #              CERCARE UN MODO PER FARE IL TUTTO CON SCENARIO OUTLINE           #
    #                                                                               #
    #################################################################################

    Background:
        Given systems up
        And EC old version

    Scenario:
        Given initial XML verifyRPT
            """

            """

    Scenario:
        Given initial XML activateRPT
            """

            """

    Scenario:
        Given initial XML sendRPT
            """

            """
    Scenario:
        Given initial XML sendRT
            """

            """

    # [FLUSSO_OK_qrCode_aux0]
    Scenario: verifyRPT phase
        Given qrc:AuxDigit with 0 in verifyRPT
        When PSP sends verifyRPT to nodo-dei-pagamenti
        Then check esito is OK of verifyRPT response

    Scenario: activateRPT phase
        Given the verifyRPT phase scenario request executed successfully
        And qrc:AuxDigit with 0 in activateRPT
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


    # [FLUSSO_OK_qrCode_aux1]
    Scenario: qrCode_aux1
        Given qrc:AuxDigit with 1 in verifyRPT
        When PSP sends verifyRPT to nodo-dei-pagamenti
        Then check esito is OK of verifyRPT response

    Scenario: activateRPT phase
        Given the verifyRPT phase scenario request executed successfully
        Given qrc:AuxDigit with 1 in activateRPT
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

    # [FLUSSO_OK_qrCode_aux2]
    Scenario: qrCode_aux2
        Given qrc:AuxDigit with 2 in verifyRPT
        When PSP sends verify to nodo-dei-pagamenti
        Then check esito is OK of verifyRPT

    Scenario: activateRPT phase
        Given the verifyRPT phase scenario request executed successfully
        And qrc:AuxDigit with 2 in activateRPT
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

    # [FLUSSO_OK_qrCode_aux3]
    Scenario: qrCode_aux3
        Given qrc:AuxDigit with 3 in verifyRPT
        When PSP sends verify to nodo-dei-pagamenti
        Then check esito is OK of verifyRPT response

    Scenario: activateRPT phase
        Given the verifyRPT phase scenario request executed successfully
        And qrc:AuxDigit with 3 in activateRPT
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





