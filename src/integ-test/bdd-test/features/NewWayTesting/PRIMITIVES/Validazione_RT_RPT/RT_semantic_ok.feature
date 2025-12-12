Feature: Semantic checks for nodoInviaRT - OK 1583

    Background:
        Given systems up


    @ALL @PRIMITIVE @RTSNTOK @RTSNTOK_1
    Scenario Outline: Semantic check of nodoInviaRT
        Given RPT generation RPT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | ibanAddebito                      | IT45R0760103200000000001016     |
            | identificativoUnivocoVersamento   | #IUV_#                          |
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
            | identificativoUnivocoVersamento       | $IUV_                           |
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
            | identificativoUnivocoVersamento   | $IUV_                           |
            | identificativoUnivocoRiscossione  | $IUV_                           |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
            | esitoSingoloPagamento             | TUTTO_OK                        |
            | dataEsitoSingoloPagamento         | #date#                          |
        And <elem> with <value> in rtAttachmentBody
        And RT rtAttachmentBody to base64
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canale#                        |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $IUV_                           |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check esito is OK of nodoInviaRT response
        Examples:
            | SoapUI  | elem                                    | value                                   |
            | RTSEM1  | pay_i:versioneOggetto                   | 6.0                                     |
            | RTSEM5  | pay_i:identificativoStazioneRichiedente | 90000000002_01                          |
            | RTSEM6  | pay_i:identificativoStazioneRichiedente | None                                    |
            | RTSEM9  | pay_i:dataOraMessaggioRicevuta          | 2017-09-14T11:24:10                     |
            | RTSEM10 | pay_i:riferimentoMessaggioRichiesta     | MSGRICHIESTA03                          |
            | RTSEM12 | pay_i:codiceIdentificativoUnivoco       | 1111111111                              |
            | RTSEM13 | pay_i:denominazioneBeneficiario         | AZIENDA XXX                             |
            | RTSEM14 | pay_i:codiceUnitOperBeneficiario        | 12253                                   |
            | RTSEM15 | pay_i:codiceUnitOperBeneficiario        | None                                    |
            | RTSEM17 | pay_i:denomUnitOperBeneficiario         | XX1                                     |
            | RTSEM18 | pay_i:denomUnitOperBeneficiario         | None                                    |
            | RTSEM20 | pay_i:indirizzoBeneficiario             | XX1                                     |
            | RTSEM21 | pay_i:indirizzoBeneficiario             | None                                    |
            | RTSEM23 | pay_i:civicoBeneficiario                | XX1                                     |
            | RTSEM24 | pay_i:civicoBeneficiario                | None                                    |
            | RTSEM26 | pay_i:capBeneficiario                   | XX111                                   |
            | RTSEM27 | pay_i:capBeneficiario                   | None                                    |
            | RTSEM28 | pay_i:localitaBeneficiario              | XX111                                   |
            | RTSEM29 | pay_i:localitaBeneficiario              | Napoli                                  |
            | RTSEM30 | pay_i:localitaBeneficiario              | None                                    |
            | RTSEM32 | pay_i:provinciaBeneficiario             | XX                                      |
            | RTSEM33 | pay_i:provinciaBeneficiario             | None                                    |
            | RTSEM35 | pay_i:nazioneBeneficiario               | XX                                      |
            | RTSEM36 | pay_i:nazioneBeneficiario               | None                                    |
            | RTSEM38 | pay_i:tipoIdentificativoUnivoco         | G                                       |
            | RTSEM39 | pay_i:codiceIdentificativoUnivoco       | AAAAAA77B17B428F                        |
            | RTSEM40 | pay_i:anagraficaVersante                | GesualdoModificato;RiccitelliModificato |
            | RTSEM41 | pay_i:indirizzoVersante                 | via lattanzio                           |
            | RTSEM42 | pay_i:indirizzoVersante                 | None                                    |
            | RTSEM44 | pay_i:civicoVersante                    | XX                                      |
            | RTSEM45 | pay_i:civicoVersante                    | None                                    |
            | RTSEM47 | pay_i:capVersante                       | XX111                                   |
            | RTSEM48 | pay_i:capVersante                       | None                                    |
            | RTSEM50 | pay_i:localitaVersante                  | XXXX                                    |
            | RTSEM51 | pay_i:localitaVersante                  | None                                    |
            | RTSEM53 | pay_i:provinciaVersante                 | XX                                      |
            | RTSEM54 | pay_i:provinciaVersante                 | None                                    |
            | RTSEM56 | pay_i:nazioneVersante                   | XX                                      |
            | RTSEM57 | pay_i:nazioneVersante                   | None                                    |
            | RTSEM59 | pay_i:e-mailVersante                    | GesualdoModificato.riccitelli@poste.it  |
            | RTSEM60 | pay_i:e-mailVersante                    | None                                    |
            | RTSEM62 | pay_i:tipoIdentificativoUnivoco         | G                                       |
            | RTSEM63 | pay_i:codiceIdentificativoUnivoco       | AAAAAA77B17B428F                        |
            | RTSEM64 | pay_i:anagraficaPagatore                | GesualdoMOdificato;RiccitelliModificato |
            | RTSEM65 | pay_i:indirizzoPagatore                 | via del gesu Modificato                 |
            | RTSEM66 | pay_i:indirizzoPagatore                 | None                                    |
            | RTSEM68 | pay_i:civicoPagatore                    | XX                                      |
            | RTSEM69 | pay_i:civicoPagatore                    | None                                    |
            | RTSEM71 | pay_i:capPagatore                       | XX111                                   |
            | RTSEM72 | pay_i:capPagatore                       | None                                    |
            | RTSEM74 | pay_i:localitaPagatore                  | XXXX                                    |
            | RTSEM75 | pay_i:localitaPagatore                  | None                                    |
            | RTSEM77 | pay_i:provinciaPagatore                 | XX                                      |
            | RTSEM78 | pay_i:provinciaPagatore                 | None                                    |
            | RTSEM80 | pay_i:nazionePagatore                   | XX                                      |
            | RTSEM81 | pay_i:nazionePagatore                   | None                                    |
            | RTSEM83 | pay_i:e-mailPagatore                    | GesualdoModificato.riccitelli@poste.it  |
            | RTSEM84 | pay_i:e-mailPagatore                    | None                                    |
            | RTSEM92 | pay_i:causaleVersamento                 | XXXX                                    |
            | RTSEM93 | pay_i:datiSpecificiRiscossione          | 1/def                                   |
    #| RTSEM7  | pay_i:identificativoDominio             | None                                    |


    @ALL @PRIMITIVE @RTSNTOK @RTSNTOK_2
    Scenario: Semantic checks of nodoInviaRT [RTSEM91]
        Given RPT generation RPT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | ibanAddebito                      | IT45R0760103200000000001016     |
            | identificativoUnivocoVersamento   | #IUV_#                          |
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
            | identificativoUnivocoVersamento       | $IUV_                           |
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
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 0.00                            |
            | identificativoUnivocoVersamento   | $IUV_                           |
            | identificativoUnivocoRiscossione  | $IUV_                           |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 1                               |
            | singoloImportoPagato              | 0.00                            |
            | esitoSingoloPagamento             | TUTTO_OK                        |
            | dataEsitoSingoloPagamento         | #date#                          |
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canale#                        |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $IUV_                           |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check esito is OK of nodoInviaRT response


    @ALL @PRIMITIVE @RTSNTOK @RTSNTOK_3
    #SULL'EXCEL DA PPT_SEMANTICA MENTRE SU SOAPUI OK
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
        And RT body generation RT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $iuv                            |
            | identificativoUnivocoRiscossione  | $iuv                            |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
            | esitoSingoloPagamento             | TUTTO_OK                        |
            | dataEsitoSingoloPagamento         | #date#                          |
        And <elem> with <value> in rtAttachmentBody
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
        Then check esito is OK of nodoInviaRPT response
        And check esito is OK of nodoInviaRT response
        Examples:
            | elem                    | value | test    |
            | pay_i:civicoVersante    | None  | RTSEM46 |
            | pay_i:capVersante       | None  | RTSEM49 |
            | pay_i:localitaVersante  | None  | RTSEM52 |
            | pay_i:provinciaVersante | None  | RTSEM55 |
            | pay_i:nazioneVersante   | None  | RTSEM58 |
            | pay_i:e-mailVersante    | None  | RTSEM61 |
            | pay_i:indirizzoPagatore | None  | RTSEM67 |
            | pay_i:civicoPagatore    | None  | RTSEM70 |
            | pay_i:capPagatore       | None  | RTSEM73 |
            | pay_i:localitaPagatore  | None  | RTSEM76 |
            | pay_i:provinciaPagatore | None  | RTSEM79 |
            | pay_i:nazionePagatore   | None  | RTSEM82 |
            | pay_i:e-mailPagatore    | None  | RTSEM85 |


    @ALL @PRIMITIVE @RTSNTOK @RTSNTOK_4
    Scenario: Semantic checks of nodoInviaRT [RTSEM94]
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
        And RT generation RT_generation_full with datatable vertical
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
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check esito is OK of nodoInviaRT response


    @ALL @PRIMITIVE @RTSNTOK @RTSNTOK_5
    Scenario: Semantic checks of nodoInviaRT [RTSEM89]
        Given RPT generation RPT_generation_with_2_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | ibanAddebito                      | IT45R0760103200000000001016     |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | importoSingoloVersamento          | 5.00                            |
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
        And RT generation RT_generation_full_with_2_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $iuv                            |
            | identificativoUnivocoRiscossione  | $iuv                            |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 5.00                            |
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
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check esito is OK of nodoInviaRT response


    @ALL @PRIMITIVE @RTSNTOK @RTSNTOK_7
    Scenario Outline: Semantic check of nodoInviaRPT
        Given RPT body generation RPT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | ibanAddebito                      | IT45R0760103200000000001016     |
            | identificativoUnivocoVersamento   | #IUV_#                          |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | importoSingoloVersamento          | 10.00                           |
            | anagraficaPagatore                | Gesualdo;Riccitelli             |
            | indirizzoPagatore                 | via del gesu                    |
            | civicoPagatore                    | 11                              |
        And <elem> with <value> in rptAttachmentBody
        And RPT rptAttachmentBody to base64
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $IUV_                           |
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
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $IUV_                           |
            | identificativoUnivocoRiscossione  | IRPTRES05_01                    |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
            | esitoSingoloPagamento             | TUTTO_OK                        |
            | dataEsitoSingoloPagamento         | #date#                          |
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canale#                        |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $IUV_                           |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        Examples:
            | SoapUI  | elem                                    | value |
            | RTSEM7  | pay_i:identificativoStazioneRichiedente | None  |
            | RTSEM16 | pay_i:codiceUnitOperBeneficiario        | None  |
            | RTSEM19 | pay_i:denomUnitOperBeneficiario         | None  |
            | RTSEM22 | pay_i:indirizzoBeneficiario             | None  |
            | RTSEM25 | pay_i:civicoBeneficiario                | None  |
            | RTSEM28 | pay_i:civicoBeneficiario                | None  |
            | RTSEM31 | pay_i:localitaBeneficiario              | None  |
            | RTSEM34 | pay_i:provinciaBeneficiario             | None  |
            | RTSEM37 | pay_i:nazioneBeneficiario               | None  |
            | RTSEM43 | pay_i:indirizzoVersante                 | None  |