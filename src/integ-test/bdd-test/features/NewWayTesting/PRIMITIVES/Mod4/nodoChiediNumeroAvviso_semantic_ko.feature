Feature: semantic checks 927

    Background:
        Given systems up

    @ALL @PRIMITIVE @NM4 @NM4SENODCAKO @NM4SENODCAKO_1
    Scenario Outline: tests for demandPaymentNotice
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001      | #creditor_institution_code# |
        And <tag> with <value> in nodoChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is <faultCode> of nodoChiediNumeroAvviso response
        And check description is <description> of nodoChiediNumeroAvviso response
        Examples:
            | tag                            | value       | faultCode                | description                                      |
            | idServizio                     | 99999       | PPT_SERVIZIO_SCONOSCIUTO | Servizio inesistente sul sistema pagoPA          |
            | idServizio                     | 00200       | PPT_VERSIONE_SERVIZIO    | Versione servizio incompatibile con la chiamata  |
            | identificativoIntermediarioPSP | 91000000001 | PPT_AUTORIZZAZIONE       | Configurazione intermediario-canale non corretta |

    @ALL @PRIMITIVE @NM4 @NM4SENODCAKO @NM4SENODCAKO_2
    Scenario Outline: KO
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001      | #creditor_institution_code# |
        And <tag> with <value> in nodoChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is <faultCode> of nodoChiediNumeroAvviso response
        Examples:
            | tag                            | value              | faultCode                          |
            | identificativoPSP              | 1230984759         | PPT_PSP_SCONOSCIUTO                |
            | identificativoPSP              | NOT_ENABLED        | PPT_PSP_DISABILITATO               |
            | identificativoIntermediarioPSP | 1230984759         | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  |
            | identificativoIntermediarioPSP | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO |
            | identificativoCanale           | 1230984759         | PPT_CANALE_SCONOSCIUTO             |
            | identificativoCanale           | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO            |
            | password                       | password           | PPT_AUTENTICAZIONE                 |