Feature: Syntax checks KO for nodoAttivaRPT 1413
    Background:
        Given systems up


    @ALL @PRIMITIVE @OM3 @OM3NDATRPTSNTKO @OM3NDATRPTSNTKO_1
    Scenario Outline: Execute nodoAttivaRPT [ARPTRES1]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoAttivaRPT
            | identificativoIntermediarioPSPPagamento | #psp#                                 |
            | identificativoCanalePagamento           | #canale#                              |
            | identificativoPSP                       | #psp#                                 |
            | identificativoIntermediarioPSP          | #psp#                                 |
            | identificativoCanale                    | #canale#                              |
            | password                                | pwd                                   |
            | codiceContestoPagamento                 | CCD01                                 |
            | codificaInfrastrutturaPSP               | BARCODE-GS1-128                       |
            | Gln                                     | #creditor_institution_code_secondary# |
            | AuxDigit                                | 3                                     |
            | CodIUV                                  | 11102281035412050                     |
            | importoSingoloVersamento                | 10.00                                 |
        And from body with datatable horizontal paaAttivaRPT_KO_simple initial XML paaAttivaRPT
            | esito |
            | KO    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoAttivaRPT response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response



    @ALL @PRIMITIVE @OM3 @OM3NDATRPTSNTKO @OM3NDATRPTSNTKO_2
    Scenario: Execute nodoAttivaRPT [ARPTRES2]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoAttivaRPT
            | identificativoIntermediarioPSPPagamento | #psp#                                 |
            | identificativoCanalePagamento           | #canale#                              |
            | identificativoPSP                       | #psp#                                 |
            | identificativoIntermediarioPSP          | #psp#                                 |
            | identificativoCanale                    | #canale#                              |
            | password                                | pwd                                   |
            | codiceContestoPagamento                 | CCD01                                 |
            | codificaInfrastrutturaPSP               | BARCODE-GS1-128                       |
            | Gln                                     | #creditor_institution_code_secondary# |
            | AuxDigit                                | 3                                     |
            | CodIUV                                  | 11102281035412050                     |
            | importoSingoloVersamento                | 10.00                                 |
        And from body with datatable vertical paaAttivaRPT_KO_full initial XML paaAttivaRPT
            | faultCode                | PAA_SEMANTICA                         |
            | faultString              | Firma non disponibile                 |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | OK                                    |
            | importoSingoloVersamento | 100.00                                |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response



    @ALL @PRIMITIVE @OM3 @OM3NDATRPTSNTKO @OM3NDATRPTSNTKO_3
    Scenario Outline: Execute nodoAttivaRPT
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoAttivaRPT
            | identificativoIntermediarioPSPPagamento | #psp#                                 |
            | identificativoCanalePagamento           | #canale#                              |
            | identificativoPSP                       | #psp#                                 |
            | identificativoIntermediarioPSP          | #psp#                                 |
            | identificativoCanale                    | #canale#                              |
            | password                                | pwd                                   |
            | codiceContestoPagamento                 | CCD01                                 |
            | codificaInfrastrutturaPSP               | BARCODE-GS1-128                       |
            | Gln                                     | #creditor_institution_code_secondary# |
            | AuxDigit                                | 3                                     |
            | CodIUV                                  | 11102281035412050                     |
            | importoSingoloVersamento                | 10.00                                 |
        And from body with datatable vertical paaAttivaRPT_KO_full initial XML paaAttivaRPT
            | faultCode                | PAA_SEMANTICA                         |
            | faultString              | Firma non disponibile                 |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | OK                                    |
            | importoSingoloVersamento | 100.00                                |
        And <field> with <value> in paaAttivaRPT
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
        Examples:
            | field                    | value | soapUI test |
            | importoSingoloVersamento | Empty | ARPTRES3    |



    @ALL @PRIMITIVE @OM3 @OM3NDATRPTSNTKO @OM3NDATRPTSNTKO_4
    Scenario Outline: Execute nodoAttivaRPT
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoAttivaRPT
            | identificativoIntermediarioPSPPagamento | #psp#                                 |
            | identificativoCanalePagamento           | #canale#                              |
            | identificativoPSP                       | #psp#                                 |
            | identificativoIntermediarioPSP          | #psp#                                 |
            | identificativoCanale                    | #canale#                              |
            | password                                | pwd                                   |
            | codiceContestoPagamento                 | CCD01                                 |
            | codificaInfrastrutturaPSP               | BARCODE-GS1-128                       |
            | Gln                                     | #creditor_institution_code_secondary# |
            | AuxDigit                                | 3                                     |
            | CodIUV                                  | 11102281035412050                     |
            | importoSingoloVersamento                | 10.00                                 |
        And from body with datatable vertical paaAttivaRPT_KO_full initial XML paaAttivaRPT
            | faultCode                | PAA_SEMANTICA                         |
            | faultString              | Firma non disponibile                 |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | OK                                    |
            | importoSingoloVersamento | 100.00                                |
        And <field1> with <value1> in paaAttivaRPT
        And <field2> with <value2> in paaAttivaRPT
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
        Examples:
            | field1 | value1 | field2                   | value2 | soapUI test |
            | fault  | None   | causaleVersamento        | None   | ARPTRES4    |
            | fault  | None   | importoSingoloVersamento | 100.0  | ARPTRES7    |
            | fault  | None   | importoSingoloVersamento | 100    | ARPTRES8    |



    @ALL @PRIMITIVE @OM3 @OM3NDATRPTSNTKO @OM3NDATRPTSNTKO_5
    Scenario Outline: Execute nodoAttivaRPT
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoAttivaRPT
            | identificativoIntermediarioPSPPagamento | #psp#                                 |
            | identificativoCanalePagamento           | #canale#                              |
            | identificativoPSP                       | #psp#                                 |
            | identificativoIntermediarioPSP          | #psp#                                 |
            | identificativoCanale                    | #canale#                              |
            | password                                | pwd                                   |
            | codiceContestoPagamento                 | CCD01                                 |
            | codificaInfrastrutturaPSP               | BARCODE-GS1-128                       |
            | Gln                                     | #creditor_institution_code_secondary# |
            | AuxDigit                                | 3                                     |
            | CodIUV                                  | 11102281035412050                     |
            | importoSingoloVersamento                | 10.00                                 |
        And from body with datatable vertical paaAttivaRPT_KO_full initial XML paaAttivaRPT
            | faultCode                | PAA_SEMANTICA                         |
            | faultString              | Firma non disponibile                 |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | OK                                    |
            | importoSingoloVersamento | 100.00                                |
        And <field> with <value> in paaAttivaRPT
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
        Examples:
            | field                    | value | soapUI test |
            | importoSingoloVersamento | Empty | ARPTRES3    |
            | causaleVersamento        | Empty | ARPTRES4    |


    @ALL @PRIMITIVE @OM3 @OM3NDATRPTSNTKO @OM3NDATRPTSNTKO_6
    Scenario Outline: Execute nodoAttivaRPT
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc_noOptional initial XML nodoAttivaRPT
            | identificativoIntermediarioPSPPagamento | #psp#                                 |
            | identificativoCanalePagamento           | #canale#                              |
            | identificativoPSP                       | #psp#                                 |
            | identificativoIntermediarioPSP          | #psp#                                 |
            | identificativoCanale                    | #canale#                              |
            | password                                | pwd                                   |
            | codiceContestoPagamento                 | CCD01                                 |
            | codificaInfrastrutturaPSP               | BARCODE-GS1-128                       |
            | Gln                                     | #creditor_institution_code_secondary# |
            | AuxDigit                                | 3                                     |
            | CodIUV                                  | 11102281035412050                     |
            | importoSingoloVersamento                | 10.00                                 |
        And from body with datatable vertical paaAttivaRPT_KO_fake_tag initial XML paaAttivaRPT
            | faultCode                | PAA_SEMANTICA                         |
            | faultString              | Firma non disponibile                 |
            | id                       | #creditor_institution_code_secondary# |
            | esito                    | OK                                    |
            | importoSingoloVersamento | 100.00                                |
        And <field> with <value> in paaAttivaRPT
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
        Examples:
            | field                                | value | soapUI test |
            | spezzoneStrutturatoCausaleVersamento | None  | ARPTRES5    |
            | causaleVersamento                    | None  | ARPTRES6    |
            
