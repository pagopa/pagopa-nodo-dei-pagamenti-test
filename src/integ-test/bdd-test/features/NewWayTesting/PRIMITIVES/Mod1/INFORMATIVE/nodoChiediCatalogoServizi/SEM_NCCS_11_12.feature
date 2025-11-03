Feature: Semantic checks KO for nodoChiediCatalogoServizi 225
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMNCCSKO @MOD1SEMNCCSKO_11
    Scenario: Check SEM_NCCS_11
        Given from body with datatable horizontal nodoChiediCatalogoServizi_noOptional initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   |
            | #psp#             | #psp#                          | #canale_ATTIVATO_PRESSO_PSP# | #password# |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        # CDS_SERVIZIO
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value           |
            | ID_SERVIZIO | NotNone,NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table CDS_SERVIZIO retrived by the query on db nodo_cfg with where datatable horizontal
            | where_keys | where_values |
            | VERSIONE   | 1            |


    @ALL @PRIMITIVE @MOD1 @MOD1SEMNCCSKO @MOD1SEMNCCSKO_12
    Scenario: Check SEM_NCCS_12
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio |
            | #psp#             | #psp#                          | #canale_ATTIVATO_PRESSO_PSP# | #password# | #intermediarioPA#     |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response