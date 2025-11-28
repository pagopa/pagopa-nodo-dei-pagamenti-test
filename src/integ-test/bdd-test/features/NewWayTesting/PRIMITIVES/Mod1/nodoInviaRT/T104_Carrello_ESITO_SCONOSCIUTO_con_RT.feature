Feature: T104_Carrello_ESITO_SCONOSCIUTO_con_RT 477
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1NICRTOK @MOD1NICRTOK_2
    Scenario: Carrello_ESITO_SCONOSCIUTO_con_RT
        Given MB1 generation MBD_generation_diff_DGV with datatable vertical
            | CodiceFiscale | 12345678901                                  |
            | Denominazione | idPsp1                                       |
            | IUBD          | #iubd1#                                      |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | 1HpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And MB2 generation MBD_generation_diff_DGV with datatable vertical
            | CodiceFiscale | 12345678901                                  |
            | Denominazione | idPsp1                                       |
            | IUBD          | #iubd2#                                      |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | 2HpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And MB4 generation MBD_generation_diff_DGV with datatable vertical
            | CodiceFiscale | 12345678901                                  |
            | Denominazione | idPsp1                                       |
            | IUBD          | #iubd4#                                      |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | 4HpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT1 generation RPT_generation_with_2_payments_2MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code#                  |
            | identificativoStazioneRichiedente | #id_station#                                 |
            | dataOraMessaggioRichiesta         | #timedate#                                   |
            | dataEsecuzionePagamento           | #date#                                       |
            | importoTotaleDaVersare            | 20.00                                        |
            | codiceIdentificativoUnivoco       | 11111111117                                  |
            | identificativoUnivocoVersamento   | #iuv1#                                       |
            | codiceContestoPagamento           | CCD01                                        |
            | tipoVersamento                    | BBT                                          |
            | importoSingoloVersamento          | 10.00                                        |
            | commissioneCaricoPA               | 10.00                                        |
            | ibanAddebito                      | IT96R0123454321000000012346                  |
            | bollo1                            | 1HpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | bollo2                            | 2HpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT2 generation RPT_generation_with_2_payments_1MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 20.00                       |
            | identificativoUnivocoVersamento   | #iuv2#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | commissioneCaricoPA               | 10.00                       |
            | ibanAddebito                      | IT96R0123454321000000012346 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT45R0760103200000000001016 |
            | importoSingoloVersamento          | 10.00                       |
        And RT1 generation RT_generation_with_2MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 20.00                       |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | identificativoUnivocoRiscossione  | $1iuv                       |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | esitoSingoloPagamento             | Pagamento effettuato        |
            | testoAllegato1                    | $1bollo                     |
            | testoAllegato2                    | $2bollo                     |
        And RT2 generation RT_generation_full_with_2_payments_1MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 20.00                       |
            | identificativoUnivocoVersamento   | $2iuv                       |
            | identificativoUnivocoRiscossione  | $2iuv                       |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | esitoSingoloPagamento             | Pagamento effettuato        |
            | bollo                             | $4bollo                     |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrello#                  |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio1                | #creditor_institution_code# |
            | identificativoUnivocoVersamento1      | $1iuv                       |
            | codiceContestoPagamento1              | CCD01                       |
            | rpt1                                  | $rpt1Attachment             |
            | identificativoDominio2                | #creditor_institution_code# |
            | identificativoUnivocoVersamento2      | $2iuv                       |
            | codiceContestoPagamento2              | CCD01                       |
            | rpt2                                  | $rpt2Attachment             |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Given from body with datatable horizontal paaInviaRT initial XML paaInviaRT
            | esito |
            | OK    |
        And EC replies to nodo-dei-pagamenti with the paaInviaRT
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoDominio           | #creditor_institution_code# |
            | identificativoUnivocoVersamento | $1iuv                       |
            | codiceContestoPagamento         | CCD01                       |
            | password                        | #password#                  |
            | identificativoPSP               | #psp#                       |
            | identificativoIntermediarioPSP  | #psp#                       |
            | identificativoCanale            | #canaleRtPush#              |
            | rt                              | $rt1Attachment              |
            | forzaControlloSegno             | 1                           |
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And wait 11 seconds for expiration
        # DB Check
        # STATI_RPT_SNAPSHOT #iuv1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                |
            | IUV        | $1iuv                       |
            | ID_DOMINIO | #creditor_institution_code# |
            | ORDER BY   | INSERTED_TIMESTAMP ASC      |
        # STATI_RPT_SNAPSHOT #iuv2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value             |
            | STATO  | RPT_ACCETTATA_PSP |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                |
            | IUV        | $2iuv                       |
            | ID_DOMINIO | #creditor_institution_code# |
            | ORDER BY   | INSERTED_TIMESTAMP ASC      |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value              |
            | STATO  | CART_ACCETTATO_PSP |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_CARRELLO_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                 |
            | ID_CARRELLO | $nodoInviaCarrelloRPT.identificativoCarrello |