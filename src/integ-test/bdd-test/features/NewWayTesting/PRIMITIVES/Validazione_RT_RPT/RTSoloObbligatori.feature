Feature: RTSoloObbligatori 1581

    Background:
        Given systems up


    @ALL @PRIMITIVE @RPTSNTOK @RPTSNTOK_3
    Scenario Outline: Execute nodoInviaRT [RTSoloObbligatori]
        Given RPT generation RPT_generation_noOptional with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | PO                          |
            | importoSingoloVersamento          | 10.00                       |
        And RT body generation RT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | esitoSingoloPagamento             | Pagamento effettuato        |
            | dataEsitoSingoloPagamento         | #date#                      |
        And <elem> with <value> in rtAttachmentBody
        And RT rtAttachmentBody to base64
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | CCD01                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | rpt                                   | $rptAttachment              |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#             |
            | identificativoCanale            | #canaleRtPush#    |
            | password                        | #password#        |
            | identificativoPSP               | #psp#             |
            | identificativoDominio           | #intermediarioPA# |
            | identificativoUnivocoVersamento | $iuv              |
            | codiceContestoPagamento         | CCD01             |
            | forzaControlloSegno             | 1                 |
            | rt                              | $rtAttachment     |
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        Examples:
            | elem                                    | value |
            | pay_i:identificativoStazioneRichiedente | None  |


