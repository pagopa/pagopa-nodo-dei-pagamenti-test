Feature: CarrelloRPT_tipo_versamenti_differenti 488

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1CARPTOK @MMOD1CARPTOK
    Scenario Outline: Check outcome is OK for nodoInviaCarrelloRPT
        Given RPT body generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #IUV#                       |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | OBEP                        |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And <tag> with <tag_value> in rptAttachmentBody
        And RPT rptAttachmentBody to base64
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrelloMills#             |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $IUV                        |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rptAttachment              |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url field exists in nodoInviaCarrelloRPT response
        Examples:
            | SoapUI                  | tag                  | tag_value |
            | T067_CarrelloRPT_BBT    | pay_i:tipoVersamento | BBT       |
            | T068_CarrelloRPT_BP     | pay_i:tipoVersamento | BP        |
            | T068_A_CarrelloRPT_OBEP | pay_i:tipoVersamento | OBEP      |
            | T069_CarrelloRPT_AD     | pay_i:tipoVersamento | AD        |
            | T070_CarrelloRPT_CP     | pay_i:tipoVersamento | CP        |
            | T071_CarrelloRPT_PO     | pay_i:tipoVersamento | PO        |