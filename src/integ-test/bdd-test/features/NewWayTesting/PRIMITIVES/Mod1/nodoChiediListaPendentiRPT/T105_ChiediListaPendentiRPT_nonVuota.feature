Feature: T105_ChiediListaPendentiRPT_nonVuota 611
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1CLPROK @MOD1CLPROK_1
    Scenario: T105_ChiediListaPendentiRPT_nonVuota
        Given RPT generation RPT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | importoSingoloVersamento          | 10.00                       |
            | anagraficaPagatore                | Gesualdo;Riccitelli         |
            | indirizzoPagatore                 | via del gesu                |
            | civicoPagatore                    | 11                          |
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | CCD01                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp_AGID#                  |
            | identificativoIntermediarioPSP        | #broker_AGID#               |
            | identificativoCanale                  | #canale_AGID_BBT#           |
            | rpt                                   | $rptAttachment              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url
        Given from body with datatable vertical nodoChiediListaPendentiRPT_full initial XML nodoChiediListaPendentiRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | password                              | #password#                  |
            | identificativoDominio                 | #creditor_institution_code# |
            | rangeDa                               | #yesterday_date#            |
            | rangeA                                | #tomorrow_date#             |
            | dimensioneLista                       | 5                           |
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediListaPendentiRPT response
        And check listaRPTPendenti field exists in nodoChiediListaPendentiRPT response
        And check identificativoUnivocoVersamento field exists in nodoChiediListaPendentiRPT response