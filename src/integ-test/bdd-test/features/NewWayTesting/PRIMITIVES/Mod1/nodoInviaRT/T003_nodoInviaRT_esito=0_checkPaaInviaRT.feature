Feature: T003_nodoInviaRT_esito=0_checkPaaInviaRT 514

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1NIRTOK @MOD1NIRTOK_3
    Scenario: nodoInviaRT_esito=0_checkPaaInviaRT
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | checkPaaInviaRT             |
            | codiceContestoPagamento           | #ccp1#                      |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And RT1 generation RT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | checkPaaInviaRT             |
            | identificativoUnivocoRiscossione  | checkPaaInviaRT             |
            | CodiceContestoPagamento           | $1ccp                       |
            | codiceEsitoPagamento              | 0                           |
            | esitoSingoloPagamento             | TUTTO_OK                    |
            | singoloImportoPagato              | 10.00                       |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | checkPaaInviaRT             |
            | codiceContestoPagamento               | $1ccp                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                           |
            | identificativoCarrello      | $1ccp                        |
            | parametriPagamentoImmediato | idBruciatura=checkPaaInviaRT |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoDominio           | #creditor_institution_code# |
            | identificativoUnivocoVersamento | checkPaaInviaRT             |
            | codiceContestoPagamento         | $1ccp                       |
            | password                        | #password#                  |
            | identificativoPSP               | #psp#                       |
            | identificativoIntermediarioPSP  | #psp#                       |
            | identificativoCanale            | #canale#                    |
            | rt                              | $rt1Attachment              |
            | forzaControlloSegno             | 1                           |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And replace sessionExpected content with $sessionToken content
        And checks the value #id_station# of the record at column STAZ_INTERMEDIARIOPA of the table RPT retrived by the query get_staz_inter_pa on db nodo_online under macro Mod1
