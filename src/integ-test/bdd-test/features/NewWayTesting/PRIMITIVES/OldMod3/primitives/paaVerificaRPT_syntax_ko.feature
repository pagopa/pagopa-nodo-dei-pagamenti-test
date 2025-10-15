Feature: Syntax checks KO for nodoAttivaRPT 1414
    Background:
        Given systems up


    @ALL @PRIMITIVE @OM3 @OM3NDPAVERPTSNTKO @OM3NDPAVERPTSNTKO_1
    Scenario: Execute nodoVerificaRPT [VRPTRES1]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                                 |
            | identificativoIntermediarioPSP | #psp#                                 |
            | identificativoCanale           | #canale#                              |
            | codiceContestoPagamento        | CCD01                                 |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128                       |
            | password                       | pwd                                   |
            | Gln                            | #creditor_institution_code_secondary# |
            | AuxDigit                       | 3                                     |
            | CodIUV                         | 11222222222222222                     |
        And from body with datatable vertical paaVerificaRPT_KO_noOptional initial XML paaVerificaRPT
            | faultCode                | PAA_FIRMA_INDISPONIBILE               |
            | faultString              | Errore                                |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | OK                                    |
            | importoSingoloVersamento | 12                                    |
            | ibanAccredito            | IT45R0760103200000000001016           |
            | causaleVersamento        | Prova                                 |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response


    @ALL @PRIMITIVE @OM3 @OM3NDPAVERPTSNTKO @OM3NDPAVERPTSNTKO_2
    Scenario Outline: Execute nodoVerificaRPT [VRPTRES2]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                                 |
            | identificativoIntermediarioPSP | #psp#                                 |
            | identificativoCanale           | #canale#                              |
            | codiceContestoPagamento        | CCD01                                 |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128                       |
            | password                       | pwd                                   |
            | Gln                            | #creditor_institution_code_secondary# |
            | AuxDigit                       | 3                                     |
            | CodIUV                         | 11222222222222222                     |
        And from body with datatable vertical paaVerificaRPT_KO_noOptional initial XML paaVerificaRPT
            | faultCode                | PAA_FIRMA_INDISPONIBILE               |
            | faultString              | Errore                                |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | KO                                    |
            | importoSingoloVersamento | 12                                    |
            | ibanAccredito            | IT45R0760103200000000001016           |
            | causaleVersamento        | Prova                                 |
        And <field> with <value> in paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field | value | soapUI test |
            | fault | None  | VRPTRES2    |


    @ALL @PRIMITIVE @OM3 @OM3NDPAVERPTSNTKO @OM3NDPAVERPTSNTKO_3
    Scenario: Execute nodoVerificaRPT [VRPTRES3]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                                 |
            | identificativoIntermediarioPSP | #psp#                                 |
            | identificativoCanale           | #canale#                              |
            | codiceContestoPagamento        | CCD01                                 |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128                       |
            | password                       | pwd                                   |
            | Gln                            | #creditor_institution_code_secondary# |
            | AuxDigit                       | 3                                     |
            | CodIUV                         | 11222222222222222                     |
        And from body with datatable vertical paaVerificaRPT_KO_noOptional initial XML paaVerificaRPT
            | faultCode                | CIAO                                  |
            | faultString              | Errore                                |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | KO                                    |
            | importoSingoloVersamento | 12                                    |
            | ibanAccredito            | IT45R0760103200000000001016           |
            | causaleVersamento        | Prova                                 |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response


    @ALL @PRIMITIVE @OM3 @OM3NDPAVERPTSNTKO @OM3NDPAVERPTSNTKO_4
    Scenario Outline: Execute nodoVerificaRPT [VRPTRES4]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                                 |
            | identificativoIntermediarioPSP | #psp#                                 |
            | identificativoCanale           | #canale#                              |
            | codiceContestoPagamento        | CCD01                                 |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128                       |
            | password                       | pwd                                   |
            | Gln                            | #creditor_institution_code_secondary# |
            | AuxDigit                       | 3                                     |
            | CodIUV                         | 11222222222222222                     |
        And from body with datatable vertical paaVerificaRPT_KO_noOptional initial XML paaVerificaRPT
            | faultCode                | PAA_FIRMA_INDISPONIBILE               |
            | faultString              | Errore                                |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | KO                                    |
            | importoSingoloVersamento | 12                                    |
            | ibanAccredito            | IT45R0760103200000000001016           |
            | causaleVersamento        | Prova                                 |
        And <field> with <value> in paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field | value | soapUI test |
            | fault | None  | VRPTRES4    |



    @ALL @PRIMITIVE @OM3 @OM3NDPAVERPTSNTKO @OM3NDPAVERPTSNTKO_5
    Scenario: Execute nodoVerificaRPT [VRPTRES5]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                                 |
            | identificativoIntermediarioPSP | #psp#                                 |
            | identificativoCanale           | #canale#                              |
            | codiceContestoPagamento        | CCD01                                 |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128                       |
            | password                       | pwd                                   |
            | Gln                            | #creditor_institution_code_secondary# |
            | AuxDigit                       | 3                                     |
            | CodIUV                         | 11222222222222222                     |
        And from body with datatable vertical paaVerificaRPT_KO_noOptional initial XML paaVerificaRPT
            | faultCode                | PAA_FIRMA_INDISPONIBILE               |
            | faultString              | Errore                                |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | SI                                    |
            | importoSingoloVersamento | 12                                    |
            | ibanAccredito            | IT45R0760103200000000001016           |
            | causaleVersamento        | Prova                                 |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response


    @ALL @PRIMITIVE @OM3 @OM3NDPAVERPTSNTKO @OM3NDPAVERPTSNTKO_6
    Scenario Outline: Execute nodoVerificaRPT [VRPTRES6]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                                 |
            | identificativoIntermediarioPSP | #psp#                                 |
            | identificativoCanale           | #canale#                              |
            | codiceContestoPagamento        | CCD01                                 |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128                       |
            | Gln                            | #creditor_institution_code_secondary# |
            | password                       | pwd                                   |
            | AuxDigit                       | 3                                     |
            | CodIUV                         | 11222222222222222                     |
        And from body with datatable vertical paaVerificaRPT_KO_noOptional initial XML paaVerificaRPT
            | faultCode                | PAA_FIRMA_INDISPONIBILE               |
            | faultString              | Errore                                |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | OK                                    |
            | importoSingoloVersamento | 12                                    |
            | ibanAccredito            | IT45R0760103200000000001016           |
            | causaleVersamento        | Prova                                 |
        And <field> with <value> in paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field | value | soapUI test |
            | fault | None  | VRPTRES6    |


    @ALL @PRIMITIVE @OM3 @OM3NDPAVERPTSNTKO @OM3NDPAVERPTSNTKO_7
    Scenario Outline: Execute nodoVerificaRPT [VRPTRES7]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                                 |
            | identificativoIntermediarioPSP | #psp#                                 |
            | identificativoCanale           | #canale#                              |
            | codiceContestoPagamento        | CCD01                                 |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128                       |
            | password                       | pwd                                   |
            | Gln                            | #creditor_institution_code_secondary# |
            | AuxDigit                       | 3                                     |
            | CodIUV                         | 11222222222222222                     |
        And from body with datatable vertical paaVerificaRPT_KO_noOptional initial XML paaVerificaRPT
            | faultCode                | PAA_FIRMA_INDISPONIBILE               |
            | faultString              | Errore                                |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | OK                                    |
            | importoSingoloVersamento | 12                                    |
            | ibanAccredito            | IT45R0760103200000000001016           |
            | causaleVersamento        | Prova                                 |
        And <field1> with <value1> in paaVerificaRPT
        And <field2> with <value2> in paaVerificaRPT
        And <field3> with <value3> in paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field1 | value1 | field2            | value2 | field3                   | value3 | soapUI test |
            | fault  | None   | causaleVersamento | None   | importoSingoloVersamento | Empty  | VRPTRES7    |


    @ALL @PRIMITIVE @OM3 @OM3NDPAVERPTSNTKO @OM3NDPAVERPTSNTKO_8
    Scenario Outline: Execute nodoVerificaRPT [VRPTRES8]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                                 |
            | identificativoIntermediarioPSP | #psp#                                 |
            | identificativoCanale           | #canale#                              |
            | codiceContestoPagamento        | CCD01                                 |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128                       |
            | password                       | pwd                                   |
            | Gln                            | #creditor_institution_code_secondary# |
            | AuxDigit                       | 3                                     |
            | CodIUV                         | 11222222222222222                     |
        And from body with datatable vertical paaVerificaRPT_KO_noOptional initial XML paaVerificaRPT
            | faultCode                | PAA_FIRMA_INDISPONIBILE               |
            | faultString              | Errore                                |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | OK                                    |
            | importoSingoloVersamento | 12                                    |
            | ibanAccredito            | IT45R0760103200000000001016           |
            | causaleVersamento        | Prova                                 |
        And <field1> with <value1> in paaVerificaRPT
        And <field2> with <value2> in paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field1 | value1 | field2            | value2 | soapUI test |
            | fault  | None   | causaleVersamento | None   | VRPTRES8    |