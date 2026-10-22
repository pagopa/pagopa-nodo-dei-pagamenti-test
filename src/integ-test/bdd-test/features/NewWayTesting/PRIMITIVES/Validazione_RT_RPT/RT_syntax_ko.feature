Feature: Syntax checks for RT - KO 1584

  Background:
    Given systems up


  @ALL @PRIMITIVE @RPTSNTKO @RPTSNTKO_1
  Scenario Outline: Check faultCode PPT_SINTASSI_XSD error on invalid RT tag
    Given RPT generation RPT_generation_full with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRichiesta         | #timedate#                  |
      | dataEsecuzionePagamento           | #date#                      |
      | importoTotaleDaVersare            | 10.00                       |
      | identificativoUnivocoVersamento   | #iuv#                       |
      | codiceContestoPagamento           | CCD01                       |
      | tipoVersamento                    | BBT                         |
      | ibanAddebito                      | IT96R0123454321000000012345 |
      | importoSingoloVersamento          | 10.00                       |
      | anagraficaPagatore                | Gesualdo;Riccitelli         |
      | indirizzoPagatore                 | via del gesu                |
      | civicoPagatore                    | 11                          |
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
      | identificativoStazioneIntermediarioPA | #id_station#                |
      | identificativoDominio                 | #creditor_institution_code# |
      | identificativoUnivocoVersamento       | $iuv                        |
      | codiceContestoPagamento               | CCD01                       |
      | password                              | #password#                  |
      | identificativoPSP                     | #psp#                       |
      | identificativoIntermediarioPSP        | #psp#                       |
      | identificativoCanale                  | #canale#                    |
      | rpt                                   | $rptAttachment              |
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
      | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    Given RT body generation RT_generation_full with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRicevuta          | #timedate#                  |
      | importoTotalePagato               | 10.00                       |
      | identificativoUnivocoVersamento   | $iuv                        |
      | identificativoUnivocoRiscossione  | $iuv                        |
      | CodiceContestoPagamento           | CCD01                       |
      | codiceEsitoPagamento              | 0                           |
      | singoloImportoPagato              | 10.00                       |
      | esitoSingoloPagamento             | TUTTO_OK                    |
      | dataEsitoSingoloPagamento         | #date#                      |
    And <elem> with <value> in rtAttachmentBody
    And RT rtAttachmentBody to base64
    And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
      | identificativoIntermediarioPSP  | #psp#                       |
      | identificativoCanale            | #canale#                    |
      | password                        | #password#                  |
      | identificativoPSP               | #psp#                       |
      | identificativoDominio           | #creditor_institution_code# |
      | identificativoUnivocoVersamento | $iuv                        |
      | codiceContestoPagamento         | CCD01                       |
      | forzaControlloSegno             | 1                           |
      | rt                              | $rtAttachment               |
    When psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRT response
    And check faultCode is PPT_SINTASSI_XSD of nodoInviaRT response
    Examples:
      | SoapUI   | elem                                    | value                                                                                                                                                                                                                                                     |
      | RTSIN1   | pay_i:versioneOggetto                   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN2   | pay_i:versioneOggetto                   | None                                                                                                                                                                                                                                                      |
      | RTSIN3   | pay_i:versioneOggetto                   | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN4   | pay_i:dominio                           | None                                                                                                                                                                                                                                                      |
      | RTSIN5   | pay_i:identificativoDominio             | None                                                                                                                                                                                                                                                      |
      | RTSIN6   | pay_i:identificativoDominio             | Empty                                                                                                                                                                                                                                                     |
      | RTSIN7   | pay_i:identificativoDominio             | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN8   | pay_i:identificativoStazioneRichiedente | Empty                                                                                                                                                                                                                                                     |
      | RTSIN9   | pay_i:identificativoStazioneRichiedente | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN10  | pay_i:identificativoMessaggioRicevuta   | None                                                                                                                                                                                                                                                      |
      | RTSIN11  | pay_i:identificativoMessaggioRicevuta   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN12  | pay_i:identificativoMessaggioRicevuta   | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN13  | pay_i:dataOraMessaggioRicevuta          | None                                                                                                                                                                                                                                                      |
      | RTSIN14  | pay_i:dataOraMessaggioRicevuta          | Empty                                                                                                                                                                                                                                                     |
      | RTSIN15  | pay_i:dataOraMessaggioRicevuta          | 2001-12-31T12:00:00:0001                                                                                                                                                                                                                                  |
      | RTSIN16  | pay_i:dataOraMessaggioRicevuta          | 2001-12-31T12:00                                                                                                                                                                                                                                          |
      | RTSIN17  | pay_i:dataOraMessaggioRicevuta          | 31-12-2001T12:00:00                                                                                                                                                                                                                                       |
      | RTSIN18  | pay_i:riferimentoMessaggioRichiesta     | None                                                                                                                                                                                                                                                      |
      | RTSIN19  | pay_i:riferimentoMessaggioRichiesta     | Empty                                                                                                                                                                                                                                                     |
      | RTSIN20  | pay_i:riferimentoMessaggioRichiesta     | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN21  | pay_i:riferimentoDataRichiesta          | None                                                                                                                                                                                                                                                      |
      | RTSIN22  | pay_i:riferimentoDataRichiesta          | Empty                                                                                                                                                                                                                                                     |
      | RTSIN23  | pay_i:riferimentoDataRichiesta          | 2001-12-31T12                                                                                                                                                                                                                                             |
      | RTSIN24  | pay_i:riferimentoDataRichiesta          | 12-31                                                                                                                                                                                                                                                     |
      | RTSIN25  | pay_i:riferimentoDataRichiesta          | 20011231                                                                                                                                                                                                                                                  |
      | RTSIN26  | pay_i:istitutoAttestante                | None                                                                                                                                                                                                                                                      |
      | RTSIN27  | pay_i:identificativoUnivocoAttestante   | None                                                                                                                                                                                                                                                      |
      | RTSIN29  | pay_i:tipoIdentificativoUnivoco         | None                                                                                                                                                                                                                                                      |
      | RTSIN30  | pay_i:tipoIdentificativoUnivoco         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN31  | pay_i:tipoIdentificativoUnivoco         | C                                                                                                                                                                                                                                                         |
      | RTSIN32  | pay_i:codiceIdentificativoUnivoco       | None                                                                                                                                                                                                                                                      |
      | RTSIN33  | pay_i:codiceIdentificativoUnivoco       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN34  | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN35  | pay_i:denominazioneAttestante           | None                                                                                                                                                                                                                                                      |
      | RTSIN36  | pay_i:denominazioneAttestante           | Empty                                                                                                                                                                                                                                                     |
      | RTSIN37  | pay_i:denominazioneAttestante           | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN38  | pay_i:codiceUnitOperAttestante          | Empty                                                                                                                                                                                                                                                     |
      | RTSIN39  | pay_i:codiceUnitOperAttestante          | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN40  | pay_i:denomUnitOperAttestante           | Empty                                                                                                                                                                                                                                                     |
      | RTSIN41  | pay_i:denomUnitOperAttestante           | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN42  | pay_i:indirizzoAttestante               | Empty                                                                                                                                                                                                                                                     |
      | RTSIN43  | pay_i:indirizzoAttestante               | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN44  | pay_i:civicoAttestante                  | Empty                                                                                                                                                                                                                                                     |
      | RTSIN45  | pay_i:civicoAttestante                  | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN46  | pay_i:capAttestante                     | Empty                                                                                                                                                                                                                                                     |
      | RTSIN47  | pay_i:capAttestante                     | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN48  | pay_i:localitaAttestante                | Empty                                                                                                                                                                                                                                                     |
      | RTSIN49  | pay_i:localitaAttestante                | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN50  | pay_i:provinciaAttestante               | Empty                                                                                                                                                                                                                                                     |
      | RTSIN51  | pay_i:provinciaAttestante               | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN52  | pay_i:nazioneAttestante                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN53  | pay_i:nazioneAttestante                 | ITT                                                                                                                                                                                                                                                       |
      | RTSIN54  | pay_i:nazioneAttestante                 | I                                                                                                                                                                                                                                                         |
      | RTSIN55  | pay_i:nazioneAttestante                 | I8                                                                                                                                                                                                                                                        |
      | RTSIN56  | pay_i:enteBeneficiario                  | None                                                                                                                                                                                                                                                      |
      | RTSIN57  | pay_i:denominazioneBeneficiario         | None                                                                                                                                                                                                                                                      |
      | RTSIN58  | pay_i:identificativoUnivocoBeneficiario | None                                                                                                                                                                                                                                                      |
      | RTSIN59  | pay_i:identificativoUnivocoBeneficiario | RemoveParent                                                                                                                                                                                                                                              |
      | RTSIN60  | pay_i:tipoIdentificativoUnivoco         | None                                                                                                                                                                                                                                                      |
      | RTSIN61  | pay_i:tipoIdentificativoUnivoco         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN62  | pay_i:tipoIdentificativoUnivoco         | PP                                                                                                                                                                                                                                                        |
      | RTSIN64  | pay_i:codiceIdentificativoUnivoco       | None                                                                                                                                                                                                                                                      |
      | RTSIN65  | pay_i:codiceIdentificativoUnivoco       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN66  | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN67  | pay_i:denominazioneBeneficiario         | None                                                                                                                                                                                                                                                      |
      | RTSIN68  | pay_i:denominazioneBeneficiario         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN69  | pay_i:denominazioneBeneficiario         | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN70  | pay_i:codiceUnitOperBeneficiario        | Empty                                                                                                                                                                                                                                                     |
      | RTSIN71  | pay_i:codiceUnitOperBeneficiario        | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN72  | pay_i:denomUnitOperBeneficiario         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN73  | pay_i:denomUnitOperBeneficiario         | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN74  | pay_i:indirizzoBeneficiario             | Empty                                                                                                                                                                                                                                                     |
      | RTSIN75  | pay_i:indirizzoBeneficiario             | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN76  | pay_i:civicoBeneficiario                | Empty                                                                                                                                                                                                                                                     |
      | RTSIN77  | pay_i:civicoBeneficiario                | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN78  | pay_i:capBeneficiario                   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN79  | pay_i:capBeneficiario                   | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN80  | pay_i:localitaBeneficiario              | Empty                                                                                                                                                                                                                                                     |
      | RTSIN81  | pay_i:localitaBeneficiario              | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN82  | pay_i:provinciaBeneficiario             | Empty                                                                                                                                                                                                                                                     |
      | RTSIN83  | pay_i:provinciaBeneficiario             | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN84  | pay_i:nazioneBeneficiario               | Empty                                                                                                                                                                                                                                                     |
      | RTSIN85  | pay_i:nazioneBeneficiario               | 1IT                                                                                                                                                                                                                                                       |
      | RTSIN86  | pay_i:soggettoVersante                  | Occurrences,2                                                                                                                                                                                                                                             |
      | RTSIN87  | pay_i:tipoIdentificativoUnivoco         | None                                                                                                                                                                                                                                                      |
      | RTSIN88  | pay_i:identificativoUnivocoVersante     | None                                                                                                                                                                                                                                                      |
      | RTSIN89  | pay_i:identificativoUnivocoVersante     | RemoveParent                                                                                                                                                                                                                                              |
      | RTSIN90  | pay_i:tipoIdentificativoUnivoco         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN91  | pay_i:tipoIdentificativoUnivoco         | PP                                                                                                                                                                                                                                                        |
      | RTSIN93  | pay_i:codiceIdentificativoUnivoco       | None                                                                                                                                                                                                                                                      |
      | RTSIN94  | pay_i:codiceIdentificativoUnivoco       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN95  | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN96  | pay_i:anagraficaVersante                | None                                                                                                                                                                                                                                                      |
      | RTSIN97  | pay_i:anagraficaVersante                | Empty                                                                                                                                                                                                                                                     |
      | RTSIN98  | pay_i:anagraficaVersante                | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN99  | pay_i:indirizzoVersante                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN100 | pay_i:indirizzoVersante                 | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN101 | pay_i:civicoVersante                    | Empty                                                                                                                                                                                                                                                     |
      | RTSIN102 | pay_i:civicoVersante                    | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN103 | pay_i:capVersante                       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN104 | pay_i:capVersante                       | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN105 | pay_i:localitaVersante                  | Empty                                                                                                                                                                                                                                                     |
      | RTSIN106 | pay_i:localitaVersante                  | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN107 | pay_i:provinciaVersante                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN108 | pay_i:provinciaVersante                 | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN109 | pay_i:nazioneVersante                   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN110 | pay_i:nazioneVersante                   | IIT                                                                                                                                                                                                                                                       |
      | RTSIN111 | pay_i:e-mailVersante                    | Empty                                                                                                                                                                                                                                                     |
      | RTSIN112 | pay_i:e-mailVersante                    | 257DDDDDDDDDDDDDDDDDDDDDDDDDFFFFFFFFFFFFFFDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFDDDmail |
      | RTSIN113 | pay_i:e-mailVersante                    | &                                                                                                                                                                                                                                                         |
      | RTSIN114 | pay_i:soggettoPagatore                  | None                                                                                                                                                                                                                                                      |
      | RTSIN115 | pay_i:anagraficaPagatore                | None                                                                                                                                                                                                                                                      |
      | RTSIN116 | pay_i:identificativoUnivocoPagatore     | None                                                                                                                                                                                                                                                      |
      | RTSIN117 | pay_i:identificativoUnivocoPagatore     | RemoveParent                                                                                                                                                                                                                                              |
      | RTSIN118 | pay_i:tipoIdentificativoUnivoco         | None                                                                                                                                                                                                                                                      |
      | RTSIN119 | pay_i:tipoIdentificativoUnivoco         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN120 | pay_i:tipoIdentificativoUnivoco         | FF                                                                                                                                                                                                                                                        |
      | RTSIN121 | pay_i:tipoIdentificativoUnivoco         | H                                                                                                                                                                                                                                                         |
      | RTSIN122 | pay_i:codiceIdentificativoUnivoco       | None                                                                                                                                                                                                                                                      |
      | RTSIN123 | pay_i:codiceIdentificativoUnivoco       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN124 | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN125 | pay_i:anagraficaPagatore                | None                                                                                                                                                                                                                                                      |
      | RTSIN126 | pay_i:anagraficaPagatore                | Empty                                                                                                                                                                                                                                                     |
      | RTSIN127 | pay_i:anagraficaPagatore                | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN128 | pay_i:indirizzoPagatore                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN129 | pay_i:indirizzoPagatore                 | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN130 | pay_i:civicoPagatore                    | Empty                                                                                                                                                                                                                                                     |
      | RTSIN131 | pay_i:civicoPagatore                    | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN132 | pay_i:capPagatore                       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN133 | pay_i:capPagatore                       | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN134 | pay_i:localitaPagatore                  | Empty                                                                                                                                                                                                                                                     |
      | RTSIN135 | pay_i:localitaPagatore                  | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN136 | pay_i:provinciaPagatore                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN137 | pay_i:provinciaPagatore                 | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN138 | pay_i:nazionePagatore                   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN139 | pay_i:nazionePagatore                   | IIT                                                                                                                                                                                                                                                       |
      | RTSIN140 | pay_i:e-mailPagatore                    | Empty                                                                                                                                                                                                                                                     |
      | RTSIN141 | pay_i:e-mailPagatore                    | 257DDDDDDDDDDDDDDDDDDDDDDDDDFFFFFFFFFFFFFFDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFDDDmail |
      | RTSIN142 | pay_i:datiPagamento                     | None                                                                                                                                                                                                                                                      |
      | RTSIN143 | pay_i:datiPagamento                     | RemoveParent                                                                                                                                                                                                                                              |
      | RTSIN144 | pay_i:codiceEsitoPagamento              | None                                                                                                                                                                                                                                                      |
      | RTSIN145 | pay_i:codiceEsitoPagamento              | Empty                                                                                                                                                                                                                                                     |
      | RTSIN146 | pay_i:codiceEsitoPagamento              | 22                                                                                                                                                                                                                                                        |
      | RTSIN147 | pay_i:codiceEsitoPagamento              | 9                                                                                                                                                                                                                                                         |
      | RTSIN148 | pay_i:importoTotalePagato               | None                                                                                                                                                                                                                                                      |
      | RTSIN149 | pay_i:importoTotalePagato               | Empty                                                                                                                                                                                                                                                     |
      | RTSIN150 | pay_i:importoTotalePagato               | Sono13Caratte                                                                                                                                                                                                                                             |
      | RTSIN151 | pay_i:importoTotalePagato               | 12                                                                                                                                                                                                                                                        |
      | RTSIN152 | pay_i:importoTotalePagato               | 23.1                                                                                                                                                                                                                                                      |
      | RTSIN153 | pay_i:importoTotalePagato               | 235,12                                                                                                                                                                                                                                                    |
      | RTSIN154 | pay_i:identificativoUnivocoVersamento   | None                                                                                                                                                                                                                                                      |
      | RTSIN155 | pay_i:identificativoUnivocoVersamento   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN156 | pay_i:identificativoUnivocoVersamento   | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN157 | pay_i:CodiceContestoPagamento           | None                                                                                                                                                                                                                                                      |
      | RTSIN158 | pay_i:CodiceContestoPagamento           | Empty                                                                                                                                                                                                                                                     |
      | RTSIN159 | pay_i:CodiceContestoPagamento           | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN160 | pay_i:datiSingoloPagamento              | Empty                                                                                                                                                                                                                                                     |
      | RTSIN161 | pay_i:datiSingoloPagamento              | Occurrences,6                                                                                                                                                                                                                                             |
      | RTSIN162 | pay_i:singoloImportoPagato              | None                                                                                                                                                                                                                                                      |
      | RTSIN163 | pay_i:singoloImportoPagato              | Empty                                                                                                                                                                                                                                                     |
      | RTSIN164 | pay_i:singoloImportoPagato              | 99                                                                                                                                                                                                                                                        |
      | RTSIN165 | pay_i:singoloImportoPagato              | 1999999999.99                                                                                                                                                                                                                                             |
      | RTSIN167 | pay_i:singoloImportoPagato              | 10.563                                                                                                                                                                                                                                                    |
      | RTSIN168 | pay_i:singoloImportoPagato              | 10,51                                                                                                                                                                                                                                                     |
      | RTSIN169 | pay_i:esitoSingoloPagamento             | Empty                                                                                                                                                                                                                                                     |
      | RTSIN170 | pay_i:esitoSingoloPagamento             | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN171 | pay_i:dataEsitoSingoloPagamento         | None                                                                                                                                                                                                                                                      |
      | RTSIN172 | pay_i:dataEsitoSingoloPagamento         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN173 | pay_i:dataEsitoSingoloPagamento         | 2001-12-31T12                                                                                                                                                                                                                                             |
      | RTSIN174 | pay_i:dataEsitoSingoloPagamento         | 2001-12-                                                                                                                                                                                                                                                  |
      | RTSIN175 | pay_i:identificativoUnivocoRiscossione  | None                                                                                                                                                                                                                                                      |
      | RTSIN176 | pay_i:identificativoUnivocoRiscossione  | Empty                                                                                                                                                                                                                                                     |
      | RTSIN177 | pay_i:identificativoUnivocoRiscossione  | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN178 | pay_i:causaleVersamento                 | None                                                                                                                                                                                                                                                      |
      | RTSIN179 | pay_i:causaleVersamento                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN180 | pay_i:causaleVersamento                 | QuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumerici12345                                                                                                             |
      | RTSIN181 | pay_i:datiSpecificiRiscossione          | None                                                                                                                                                                                                                                                      |
      | RTSIN182 | pay_i:datiSpecificiRiscossione          | Empty                                                                                                                                                                                                                                                     |
      | RTSIN183 | pay_i:datiSpecificiRiscossione          | QuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumerici12345                                                                                                             |
      | RTSIN184 | pay_i:commissioniApplicatePSP           | Empty                                                                                                                                                                                                                                                     |
      | RTSIN185 | pay_i:commissioniApplicatePSP           | 22                                                                                                                                                                                                                                                        |
      | RTSIN188 | pay_i:commissioniApplicatePSP           | 10.251                                                                                                                                                                                                                                                    |
      | RTSIN189 | pay_i:commissioniApplicatePSP           | 10,25                                                                                                                                                                                                                                                     |


  @ALL @PRIMITIVE @RPTSNTKO @RPTSNTKO_2
  Scenario: Check faultCode PPT_SINTASSI_XSD error on invalid RT tag [RTSIN28]
    Given RPT generation RPT_generation_full with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRichiesta         | #timedate#                  |
      | dataEsecuzionePagamento           | #date#                      |
      | importoTotaleDaVersare            | 10.00                       |
      | identificativoUnivocoVersamento   | #iuv#                       |
      | codiceContestoPagamento           | CCD01                       |
      | tipoVersamento                    | BBT                         |
      | ibanAddebito                      | IT96R0123454321000000012345 |
      | importoSingoloVersamento          | 10.00                       |
      | anagraficaPagatore                | Gesualdo;Riccitelli         |
      | indirizzoPagatore                 | via del gesu                |
      | civicoPagatore                    | 11                          |
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
      | identificativoStazioneIntermediarioPA | #id_station#                |
      | identificativoDominio                 | #creditor_institution_code# |
      | identificativoUnivocoVersamento       | $iuv                        |
      | codiceContestoPagamento               | CCD01                       |
      | password                              | #password#                  |
      | identificativoPSP                     | #psp#                       |
      | identificativoIntermediarioPSP        | #psp#                       |
      | identificativoCanale                  | #canale#                    |
      | rpt                                   | $rptAttachment              |
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
      | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    Given RT generation RT_generation_full_Invalid_TAG with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRicevuta          | #timedate#                  |
      | importoTotalePagato               | 10.00                       |
      | identificativoUnivocoVersamento   | $iuv                        |
      | identificativoUnivocoRiscossione  | $iuv                        |
      | CodiceContestoPagamento           | CCD01                       |
      | codiceEsitoPagamento              | 0                           |
      | singoloImportoPagato              | 10.00                       |
      | esitoSingoloPagamento             | TUTTO_OK                    |
      | dataEsitoSingoloPagamento         | #date#                      |
    And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
      | identificativoIntermediarioPSP  | #psp#                       |
      | identificativoCanale            | #canale#                    |
      | password                        | #password#                  |
      | identificativoPSP               | #psp#                       |
      | identificativoDominio           | #creditor_institution_code# |
      | identificativoUnivocoVersamento | $iuv                        |
      | codiceContestoPagamento         | CCD01                       |
      | forzaControlloSegno             | 1                           |
      | rt                              | $rtAttachment               |
    When psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRT response
    And check faultCode is PPT_SINTASSI_XSD of nodoInviaRT response


  @ALL @PRIMITIVE @RPTSNTKO @RPTSNTKO_3
  Scenario: Check faultCode PPT_SINTASSI_XSD error on invalid singoloImportoPagato [RTSIN166]
    Given RPT generation RPT_generation_full with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRichiesta         | #timedate#                  |
      | dataEsecuzionePagamento           | #date#                      |
      | importoTotaleDaVersare            | 10.00                       |
      | identificativoUnivocoVersamento   | #iuv#                       |
      | codiceContestoPagamento           | CCD01                       |
      | tipoVersamento                    | BBT                         |
      | ibanAddebito                      | IT96R0123454321000000012345 |
      | importoSingoloVersamento          | 10.00                       |
      | anagraficaPagatore                | Gesualdo;Riccitelli         |
      | indirizzoPagatore                 | via del gesu                |
      | civicoPagatore                    | 11                          |
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
      | identificativoStazioneIntermediarioPA | #id_station#                |
      | identificativoDominio                 | #creditor_institution_code# |
      | identificativoUnivocoVersamento       | $iuv                        |
      | codiceContestoPagamento               | CCD01                       |
      | password                              | #password#                  |
      | identificativoPSP                     | #psp#                       |
      | identificativoIntermediarioPSP        | #psp#                       |
      | identificativoCanale                  | #canale#                    |
      | rpt                                   | $rptAttachment              |
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
      | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    Given RT generation RT_generation_full_Invalid_TAG with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRicevuta          | #timedate#                  |
      | importoTotalePagato               | 999999999.99                |
      | identificativoUnivocoVersamento   | $iuv                        |
      | identificativoUnivocoRiscossione  | $iuv                        |
      | CodiceContestoPagamento           | CCD01                       |
      | codiceEsitoPagamento              | 0                           |
      | singoloImportoPagato              | 999999999.99                |
      | esitoSingoloPagamento             | TUTTO_OK                    |
      | dataEsitoSingoloPagamento         | #date#                      |
    And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
      | identificativoIntermediarioPSP  | #psp#                       |
      | identificativoCanale            | #canale#                    |
      | password                        | #password#                  |
      | identificativoPSP               | #psp#                       |
      | identificativoDominio           | #creditor_institution_code# |
      | identificativoUnivocoVersamento | $iuv                        |
      | codiceContestoPagamento         | CCD01                       |
      | forzaControlloSegno             | 1                           |
      | rt                              | $rtAttachment               |
    When psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRT response
    And check faultCode is PPT_SINTASSI_XSD of nodoInviaRT response