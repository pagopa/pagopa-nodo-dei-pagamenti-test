Feature: Semantic checks for nodoChiediCopiaRT - KO 1425

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCCRTKO @MOD1SEMCCRTKO_1
    Scenario Outline: Check semantic errors for nodoChiediCopiaRT primitive
        Given from body with datatable vertical nodoChiediCopiaRT initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | password                              | #password#                      |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | IUV846                          |
            | codiceContestoPagamento               | codiceContestoPagamento         |
        And <tag> with <tag_value> in nodoChiediCopiaRT
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediCopiaRT response
        Examples:
            | tag                                   | tag_value               | error                             | soapUI test |
            | identificativoIntermediarioPA         | 12345678901             | PPT_INTERMEDIARIO_PA_SCONOSCIUTO  | CCRTSEM1    |
            | identificativoIntermediarioPA         | INT_NOT_ENABLED         | PPT_INTERMEDIARIO_PA_DISABILITATO | CCRTSEM2    |
            | identificativoStazioneIntermediarioPA | unknownStation          | PPT_STAZIONE_INT_PA_SCONOSCIUTA   | CCRTSEM3    |
            | identificativoStazioneIntermediarioPA | #id_station_disabled#   | PPT_STAZIONE_INT_PA_DISABILITATA  | CCRTSEM4    |
            | password                              | wrongPassword           | PPT_AUTENTICAZIONE                | CCRTSEM5    |
            | identificativoDominio                 | 12345678922             | PPT_DOMINIO_SCONOSCIUTO           | CCRTSEM6    |
            | identificativoDominio                 | NOT_ENABLED             | PPT_DOMINIO_DISABILITATO          | CCRTSEM7    |
            | identificativoUnivocoVersamento       | wrongIUV                | PPT_RT_SCONOSCIUTA                | CCRTSEM8    |
            | codiceContestoPagamento               | wrongPaymentContextCode | PPT_RT_SCONOSCIUTA                | CCRTSEM9    |
            | identificativoIntermediarioPA         | 77777777777             | PPT_AUTORIZZAZIONE                | CCRTSEM12   |


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCCRTKO @MOD1SEMCCRTKO_2
    Scenario Outline: Check semantic errors for nodoChiediCopiaRT primitive
        Given from body with datatable vertical nodoChiediCopiaRT initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | password                              | #password#                      |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | IUV846                          |
            | codiceContestoPagamento               | codiceContestoPagamento         |
        # STATI_RPT_SNAPSHOT
        And execution query to get value result_query on the table STATI_RPT_SNAPSHOT, with the columns IUV, CCP with db name nodo_online with where datatable horizontal
            | where_keys | where_values                    |
            | STATO      | RPT_ACCETTATA_PSP               |
            | ID_DOMINIO | #creditor_institution_code_old# |
            | ORDER BY   | UPDATED_TIMESTAMP DESC LIMIT 1  |
        And through the query result_query retrieve param ccp at position 0 and save it under the key iuv
        And through the query result_query retrieve param ccp at position 1 and save it under the key ccp
        And identificativoUnivocoVersamento with <iuv_value> in nodoChiediCopiaRT
        And codiceContestoPagamento with <ccp_value> in nodoChiediCopiaRT
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediCopiaRT response
        #per il test CCRTSEM11 prendere i dati dal db dalla STATI_RPT_SNAPSHOT con STATO = 'RPT_ACCETTATA_PSP'
        Examples:
            | iuv_value         | ccp_value | error                 | soapUI test |
            | 11000679416493210 | 59050     | PPT_RT_SCONOSCIUTA    | CCRTSEM10   |
            | $iuv              | $ccp      | PPT_RT_NONDISPONIBILE | CCRTSEM11   |