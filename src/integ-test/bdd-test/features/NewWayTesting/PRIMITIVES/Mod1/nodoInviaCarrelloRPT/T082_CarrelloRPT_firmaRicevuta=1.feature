Feature: T082_CarrelloRPT_firmaRicevuta=1 602
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTKO @MOD1INCARPTKO_5
    Scenario: CarrelloRPT_firmaRicevuta=1
        Given RPT1 body generation RPT_generation_complete_soggPag with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | tipoIdentificativoUnivoco         | G                           |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And pay_i:firmaRicevuta with 1 in rpt1AttachmentBody
        And RPT1 rpt1AttachmentBody to base64
        And RPT2 generation RPT_generation_complete_soggPag with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | tipoIdentificativoUnivoco         | G                           |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | Err$1iuv                    |
            | codiceContestoPagamento           | CCD02                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrello#                  |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp_AGID#                  |
            | identificativoIntermediarioPSP        | #broker_AGID#               |
            | identificativoCanale                  | #canale_AGID_BBT#           |
            | identificativoDominio1                | #creditor_institution_code# |
            | identificativoUnivocoVersamento1      | $1iuv                       |
            | codiceContestoPagamento1              | CCD01                       |
            | rpt1                                  | $rpt1Attachment             |
            | identificativoDominio2                | #creditor_institution_code# |
            | identificativoUnivocoVersamento2      | Err$1iuv                    |
            | codiceContestoPagamento2              | CCD02                       |
            | rpt2                                  | $rpt2Attachment             |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_SINTASSI_XSD of nodoInviaCarrelloRPT response
        And check description is Errore validazione XML [RPT/datiVersamento/firmaRicevuta] - cvc-enumeration-valid: il valore "1" non è valido come facet rispetto all'enumerazione "[0]". Deve essere un valore dell'enumerazione. of nodoInviaCarrelloRPT response
