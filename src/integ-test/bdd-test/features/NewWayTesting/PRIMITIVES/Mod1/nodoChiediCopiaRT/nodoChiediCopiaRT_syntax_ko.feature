Feature: Syntax checks for nodoChiediCopiaRT - KO 1426

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SINCCRTKO @MOD1SINCCRTKO_1
    Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediCopiaRT primitive [CCRTSIN1]
        Given from body with datatable vertical nodoChiediCopiaRT_malformed initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | 44444444444             |
            | identificativoStazioneIntermediarioPA | 44444444444_01          |
            | password                              | #password#              |
            | identificativoDominio                 | 44444444444             |
            | identificativoUnivocoVersamento       | IUV846                  |
            | codiceContestoPagamento               | codiceContestoPagamento |
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCopiaRT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCCRTKO @MOD1SINCCRTKO_2
    Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediCopiaRT primitive [CCRTSIN5]
        Given from body with datatable vertical nodoChiediCopiaRT_namespace_ppt initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | 44444444444             |
            | identificativoStazioneIntermediarioPA | 44444444444_01          |
            | password                              | #password#              |
            | identificativoDominio                 | 44444444444             |
            | identificativoUnivocoVersamento       | IUV846                  |
            | codiceContestoPagamento               | codiceContestoPagamento |
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCopiaRT response



    @ALL @PRIMITIVE @MOD1 @MOD1SINCCRTKO @MOD1SINCCRTKO_3
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediCopiaRT primitive
        Given from body with datatable vertical nodoChiediCopiaRT initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | 44444444444             |
            | identificativoStazioneIntermediarioPA | 44444444444_01          |
            | password                              | #password#              |
            | identificativoDominio                 | 44444444444             |
            | identificativoUnivocoVersamento       | IUV846                  |
            | codiceContestoPagamento               | codiceContestoPagamento |
        And <tag> with <tag_value> in nodoChiediCopiaRT
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCopiaRT response
        Examples:
            | tag                                   | tag_value                            | soapUI test |
            | soapenv:Body                          | Empty                                | CCRTSIN2    |
            | soapenv:Body                          | None                                 | CCRTSIN3    |
            | ws:nodoChiediCopiaRT                  | Empty                                | CCRTSIN4    |
            | identificativoIntermediarioPA         | None                                 | CCRTSIN6    |
            | identificativoIntermediarioPA         | Empty                                | CCRTSIN7    |
            | identificativoIntermediarioPA         | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN8    |
            | identificativoStazioneIntermediarioPA | None                                 | CCRTSIN9    |
            | identificativoStazioneIntermediarioPA | Empty                                | CCRTSIN10   |
            | identificativoStazioneIntermediarioPA | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN11   |
            | password                              | None                                 | CCRTSIN12   |
            | password                              | Empty                                | CCRTSIN13   |
            | password                              | aaaaaaa                              | CCRTSIN14   |
            | password                              | aaaaaaaaaaaaaaaa                     | CCRTSIN15   |
            | identificativoDominio                 | None                                 | CCRTSIN16   |
            | identificativoDominio                 | Empty                                | CCRTSIN17   |
            | identificativoDominio                 | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN18   |
            | identificativoUnivocoVersamento       | None                                 | CCRTSIN19   |
            | identificativoUnivocoVersamento       | Empty                                | CCRTSIN20   |
            | identificativoUnivocoVersamento       | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN21   |
            | codiceContestoPagamento               | None                                 | CCRTSIN22   |
            | codiceContestoPagamento               | Empty                                | CCRTSIN23   |
            | codiceContestoPagamento               | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN24   |