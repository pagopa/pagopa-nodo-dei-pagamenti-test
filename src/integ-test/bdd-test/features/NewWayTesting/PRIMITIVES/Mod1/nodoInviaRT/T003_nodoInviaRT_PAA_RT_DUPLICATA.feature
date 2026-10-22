Feature: process tests for nodoInviaRT_PAA_RT_DUPLICATA 795

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1NIRTOK @MOD1NIRTOK_9
    Scenario: tests for nodoInviaRT_PAA_RT_DUPLICATA
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | #ccp#                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT45R0760103200000000001016 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canale#                    |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | $ccp                        |
            | rpt                                   | $rptAttachment              |
        And from body with datatable vertical pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                                                         |
            | identificativoCarrello      | $nodoInviaRPT.identificativoUnivocoVersamento              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given RT generation RT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | esitoSingoloPagamento             | TUTTO_OK                    |
            | singoloImportoPagato              | 10.00                       |
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoDominio           | #creditor_institution_code# |
            | identificativoUnivocoVersamento | $iuv                        |
            | codiceContestoPagamento         | $ccp                        |
            | password                        | #password#                  |
            | identificativoPSP               | #psp#                       |
            | identificativoIntermediarioPSP  | #psp#                       |
            | identificativoCanale            | #canale#                    |
            | rt                              | $rtAttachment               |
            | forzaControlloSegno             | 1                           |
        And from body with datatable horizontal paaInviaRT_KO initial XML paaInviaRT
            | faultCode        | faultString | id          | description | esito |
            | PAA_RT_DUPLICATA | tegba       | 66666666666 | test        | KO    |
        And EC replies to nodo-dei-pagamenti with the paaInviaRT
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And wait 2 seconds for expiration
        # RT
        And execution query to get value result_query on the table RT, with the columns ID_SESSIONE with db name nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $iuv         |
        And through the query result_query retrieve param id_sessione at position 0 and save it under the key idSessione
        # RE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                 |
            | ESITO  | RICEVUTA,CAMBIO_STATO,CAMBIO_STATO,INVIATA,CAMBIO_STATO,INVIATA,RICEVUTA,CAMBIO_STATO |
            | STATUS | None,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,None,RT_INVIATA_PA,None,None,RT_RIFIUTATA_PA  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys  | where_values    |
            | ID_SESSIONE | $idSessione     |
            | ORDER BY    | DATA_ORA_EVENTO |

