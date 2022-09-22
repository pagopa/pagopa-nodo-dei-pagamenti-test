Feature: T220_RT_faultBeanEsteso

    Background:
        Given systems up

    Scenario: Execute nodoInviaRPT (Phase 1)
        Given RPT generation
        """"""
        And RT generation
        """"""
        And initial XMl nodoInviaRPT
        """"""
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    Scenario: Execute nodoInviaRT (Phase 2)
        Given the Execute nodoInviaRPT (Phase 1) scenario executed successfully
        And initial XMl nodoInviaRT
        """"""
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRT response

    Scenario: Execute nodoChiediStatoRPT (Phase 3)
        Given the Execute nodoInviaRT (Phase 2) scenario executed successfully
        And initial XML nodoChiediStatoRPT
        """"""
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRT response
        And checks stato contains RT_RIFIUTATA_PA of nodoChiediStatoRPT response
        And checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_PSP of nodoChiediStatoRPT response
        And checks stato contains RT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RT_ACCETTATA_NODO of nodoChiediStatoRPT response
