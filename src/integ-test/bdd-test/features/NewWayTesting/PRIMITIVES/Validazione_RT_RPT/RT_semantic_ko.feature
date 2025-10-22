Feature: Semantic checks for nodoInviaRT - KO 1582

    Background:
        Given systems up

    @ALL @PRIMITIVE @RTSNTKO @RTSNTKO_1
    Scenario Outline: Semantic check of nodoInviaRT
        Given RPT generation RPT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | ibanAddebito                      | IT45R0760103200000000001016     |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | importoSingoloVersamento          | 10.00                           |
            | anagraficaPagatore                | Gesualdo;Riccitelli             |
            | indirizzoPagatore                 | via del gesu                    |
            | civicoPagatore                    | 11                              |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And RT body generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $iuv                            |
            | identificativoUnivocoRiscossione  | $iuv                            |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And <elem> with <value> in rtAttachmentBody
        And RT rtAttachmentBody to base64
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canale#                        |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $iuv+_01                        |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRT response
        And check faultCode is <error> of nodoInviaRT response
        Examples:
            | elem                                  | value    | error               | SoapUI  |
            | pay_i:identificativoUnivocoVersamento | $iuv+_01 | PPT_RPT_SCONOSCIUTA | RTSEM87 |
            | pay_i:tipoIdentificativoUnivoco       | F        | PPT_SINTASSI_XSD    | RTSEM11 |



    @ALL @PRIMITIVE @RTSNTKO @RTSNTKO_2
    # singoloImportoPagato a 0.00 a esitoSingoloPagamento with None
    Scenario Outline: Semantic check of nodoInviaRT- RTSEM90
        Given RPT generation RPT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | ibanAddebito                      | IT45R0760103200000000001016     |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | importoSingoloVersamento          | 10.00                           |
            | anagraficaPagatore                | Gesualdo;Riccitelli             |
            | indirizzoPagatore                 | via del gesu                    |
            | civicoPagatore                    | 11                              |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And RT body generation RT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $iuv                            |
            | identificativoUnivocoRiscossione  | $iuv                            |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | esitoSingoloPagamento             | TUTTO_OK                        |
            | singoloImportoPagato              | 10.00                           |
        And <elem1> with <value1> in rtAttachmentBody
        And <elem2> with <value2> in rtAttachmentBody
        And RT rtAttachmentBody to base64
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canale#                        |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $iuv                            |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRT response
        And check faultCode is PPT_SEMANTICA of nodoInviaRT response
        Examples:
            | elem1                      | value1 | elem2                       | value2 | SoapUI  |
            | pay_i:singoloImportoPagato | 0.00   | pay_i:esitoSingoloPagamento | None   | RTSEM90 |


    @ALL @PRIMITIVE @RTSNTKO @RTSNTKO_3
    Scenario: Semantic checks [RTSEM3]
        Given RPT generation RPT_generation_full with datatable vertical
            | identificativoDominio             | #paDisabled#                |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | importoSingoloVersamento          | 10.00                       |
            | anagraficaPagatore                | Gesualdo;Riccitelli         |
            | indirizzoPagatore                 | via del gesu                |
            | civicoPagatore                    | 11                          |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #paDisabled#                    |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And RT generation RT_generation_full with datatable vertical
            | identificativoDominio             | #paDisabled#     |
            | identificativoStazioneRichiedente | #id_station_old# |
            | dataOraMessaggioRicevuta          | #timedate#       |
            | importoTotalePagato               | 10.00            |
            | identificativoUnivocoVersamento   | $iuv             |
            | identificativoUnivocoRiscossione  | $iuv             |
            | CodiceContestoPagamento           | CCD01            |
            | codiceEsitoPagamento              | 0                |
            | singoloImportoPagato              | 10.00            |
            | esitoSingoloPagamento             | ACCEPTED         |
            | dataEsitoSingoloPagamento         | #date#           |
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#         |
            | identificativoCanale            | #canale#      |
            | password                        | #password#    |
            | identificativoPSP               | #psp#         |
            | identificativoDominio           | #paDisabled#  |
            | identificativoUnivocoVersamento | $iuv          |
            | codiceContestoPagamento         | CCD01         |
            | forzaControlloSegno             | 1             |
            | rt                              | $rtAttachment |
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_DOMINIO_DISABILITATO of nodoInviaRPT response
        And check esito is KO of nodoInviaRT response
        And check faultCode is PPT_DOMINIO_DISABILITATO of nodoInviaRT response
        And check description is Dominio disabilitato. of nodoInviaRT response


    @ALL @PRIMITIVE @RTSNTKO @RTSNTKO_4
    Scenario: Execute nodoInviaRPT 
        Given RPT generation RPT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | ibanAddebito                      | IT45R0760103200000000001016     |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | importoSingoloVersamento          | 10.00                           |
            | anagraficaPagatore                | Gesualdo;Riccitelli             |
            | indirizzoPagatore                 | via del gesu                    |
            | civicoPagatore                    | 11                              |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given RT generation RT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $iuv                            |
            | identificativoUnivocoRiscossione  | $iuv                            |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
            | esitoSingoloPagamento             | ACCEPTED                        |
            | dataEsitoSingoloPagamento         | #date#                          |
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canale#                        |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $iuv                            |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        And check esito is KO of nodoInviaRT response
        And check faultCode is PPT_RT_DUPLICATA of nodoInviaRT response