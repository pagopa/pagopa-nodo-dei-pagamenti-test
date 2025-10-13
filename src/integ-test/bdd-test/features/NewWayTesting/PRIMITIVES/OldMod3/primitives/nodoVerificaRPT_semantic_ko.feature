Feature: Semantic checks KO for nodoVerificaRPT 1411
    Background:
        Given systems up


    @ALL @PRIMITIVE @OM3 @NM3NOVERPSEKO @NM3NOVERPSEKO_1
    Scenario Outline: Check faultCode error on non-existent or invalid field
        Given from body with datatable vertical nodoVerificaRPT_complete initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | QR-CODE                      |
            | CF                             | #id_broker#                  |
            | CodStazPA                      | #cod_segr#                   |
            | AuxDigit                       | 0                            |
            | CodIUV                         | #iuv#                        |
        And <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is <resp_error> of nodoVerificaRPT response
        Examples:
            | field                          | value              | resp_error                         | soapUI test |
            | identificativoPSP              | pspUnknown         | PPT_PSP_SCONOSCIUTO                | VRPTSEM1    |
            | identificativoPSP              | NOT_ENABLED        | PPT_PSP_DISABILITATO               | VRPTSEM2    |
            | identificativoIntermediarioPSP | brokerPspUnknown   | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  | VRPTSEM3    |
            | identificativoIntermediarioPSP | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO | VRPTSEM4    |
            | identificativoCanale           | channelUnknown     | PPT_CANALE_SCONOSCIUTO             | VRPTSEM5    |
            | identificativoCanale           | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO            | VRPTSEM6    |
            | password                       | test_wrong_pwd     | PPT_AUTENTICAZIONE                 | VRPTSEM7    |
            | codificaInfrastrutturaPSP      | codificaErrata     | PPT_CODIFICA_PSP_SCONOSCIUTA       | VRPTSEM8    |



    @ALL @PRIMITIVE @OM3 @NM3NOVERPSEKO @NM3NOVERPSEKO_2
    Scenario Outline: Check faultCode on invalid body element
        Given from body with datatable vertical nodoVerificaRPT_complete initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | QR-CODE                      |
            | CF                             | #id_broker#                  |
            | CodStazPA                      | #cod_segr#                   |
            | AuxDigit                       | 0                            |
            | CodIUV                         | #iuv#                        |
        And <field_1> with <value_1> in nodoVerificaRPT
        And <field_2> with <value_2> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is <faultCode> of nodoVerificaRPT response
        Examples:
            | field_1      | value_1 | field_2    | value_2           | faultCode     | soapUI test |
            | qrc:AuxDigit | 0       | qrc:CodIUV | 12345678901234567 | PPT_SEMANTICA | VRPTSEM9    |
            | qrc:AuxDigit | 1       | qrc:CodIUV | 123456789012345   | PPT_SEMANTICA | VRPTSEM10   |



    @ALL @PRIMITIVE @OM3 @NM3NOVERPSEKO @NM3NOVERPSEKO_3
    Scenario Outline: Check faultCode error on invalid iuv
        Given from body with datatable vertical nodoVerificaRPT_complete initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | QR-CODE                      |
            | CF                             | #id_broker#                  |
            | CodStazPA                      | #cod_segr#                   |
            | AuxDigit                       | 0                            |
            | CodIUV                         | #iuv#                        |
        And <field_1> with <value_1> in nodoVerificaRPT
        And <field_2> with <value_2> in nodoVerificaRPT
        And <field_3> with <value_3> in nodoVerificaRPT
        And <field_4> with <value_4> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is <resp_error> of nodoVerificaRPT response
        Examples:
            | field_1      | value_1 | field_2       | value_2 | field_3    | value_3           | field_4 | value_4         | resp_error                      | soapUI test |
            | qrc:AuxDigit | 3       | qrc:CodStazPA | None    | qrc:CodIUV | 00012711162144900 | qrc:CF  | #id_broker_old# | PPT_STAZIONE_INT_PA_SCONOSCIUTA | VRPTSEM11   |
            | qrc:AuxDigit | 3       | qrc:CodStazPA | 02      | qrc:CodIUV | 00012711162144900 | qrc:CF  | #id_broker_old# | PPT_SEMANTICA                   | VRPTSEM12   |



    @ALL @PRIMITIVE @OM3 @NM3NOVERPSEKO @NM3NOVERPSEKO_4
    Scenario: Check faultCode error PPT_INTERMEDIARIO_PA_DISABILITATO [VRPTSEM13]
        Given from body with datatable vertical nodoVerificaRPT_complete initial XML nodoVerificaRPT
            | identificativoPSP              | 40000000001                 |
            | identificativoIntermediarioPSP | 40000000001                 |
            | identificativoCanale           | 40000000001_01              |
            | codiceContestoPagamento        | 130191402011917             |
            | codificaInfrastrutturaPSP      | QR-CODE                     |
            | CF                             | #creditor_institution_code# |
            | CodStazPA                      | 10                          |
            | AuxDigit                       | 0                           |
            | CodIUV                         | 015261508179300             |
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of nodoVerificaRPT response



    @ALL @PRIMITIVE @OM3 @NM3NOVERPSEKO @NM3NOVERPSEKO_5
    Scenario: Check faultCode error PPT_STAZIONE_INT_PA_SCONOSCIUTA [VRPTSEM15]
        Given from body with datatable vertical nodoVerificaRPT_complete initial XML nodoVerificaRPT
            | identificativoPSP              | 40000000001     |
            | identificativoIntermediarioPSP | 40000000001     |
            | identificativoCanale           | 40000000001_01  |
            | codiceContestoPagamento        | 122331398916990 |
            | codificaInfrastrutturaPSP      | QR-CODE         |
            | CF                             | 44444444444     |
            | CodStazPA                      | 98              |
            | AuxDigit                       | 0               |
            | CodIUV                         | 014501764115600 |
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoVerificaRPT response



    @ALL @PRIMITIVE @OM3 @NM3NOVERPSEKO @NM3NOVERPSEKO_6
    Scenario Outline: Check faultCode error on unknown or invalid CodStazPA
        Given from body with datatable vertical nodoVerificaRPT_complete initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | QR-CODE                      |
            | CF                             | #id_broker#                  |
            | CodStazPA                      | #cod_segr#                   |
            | AuxDigit                       | 0                            |
            | CodIUV                         | #iuv#                        |
        And <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is <resp_error> of nodoVerificaRPT response
        Examples:
            | field         | value       | resp_error              | soapUI test |
            | qrc:CF        | 11111122222 | PPT_DOMINIO_SCONOSCIUTO | VRPTSEM16   |
            | qrc:CF        | 77777777778 | PPT_DOMINIO_SCONOSCIUTO | VRPTSEM17   |
            | qrc:CF        | 11111122222 | PPT_DOMINIO_SCONOSCIUTO | VRPTSEM18   |
            | qrc:CodStazPA | None        | PPT_SEMANTICA           | VRPTSEM19   |



    @ALL @PRIMITIVE @OM3 @NM3NOVERPSEKO @NM3NOVERPSEKO_7
    Scenario: Check faultCode error PPT_AUTORIZZAZIONE [VRPTSEM20]
        Given from body with datatable vertical nodoVerificaRPT_complete initial XML nodoVerificaRPT
            | identificativoPSP              | 40000000001     |
            | identificativoIntermediarioPSP | 91000000001     |
            | identificativoCanale           | 40000000001_01  |
            | codiceContestoPagamento        | 153041492411187 |
            | codificaInfrastrutturaPSP      | QR-CODE         |
            | CF                             | 44444444444     |
            | CodStazPA                      | 02              |
            | AuxDigit                       | 0               |
            | CodIUV                         | 013601115164900 |
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTORIZZAZIONE of nodoVerificaRPT response