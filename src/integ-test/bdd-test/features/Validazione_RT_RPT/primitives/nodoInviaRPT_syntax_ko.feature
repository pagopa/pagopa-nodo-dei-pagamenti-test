Feature: Syntax checks for nodoInviaRPT - KO

  Background: 
    Given systems up
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    And initial XML RPT
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
      <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
      <pay_i:dominio>
          <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
          <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
      </pay_i:dominio>
      <pay_i:identificativoMessaggioRichiesta>TO_GENERATE</pay_i:identificativoMessaggioRichiesta>
      <pay_i:dataOraMessaggioRichiesta>2012-01-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
      <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
      <pay_i:soggettoVersante>
          <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
          </pay_i:identificativoUnivocoVersante>
          <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
          <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
          <pay_i:civicoVersante>11</pay_i:civicoVersante>
          <pay_i:capVersante>00186</pay_i:capVersante>
          <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
          <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
          <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
          <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
      </pay_i:soggettoVersante>
      <pay_i:soggettoPagatore>
          <pay_i:identificativoUnivocoPagatore>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
          </pay_i:identificativoUnivocoPagatore>
          <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
          <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
          <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
          <pay_i:capPagatore>00186</pay_i:capPagatore>
          <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
          <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
          <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
          <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
      </pay_i:soggettoPagatore>
      <pay_i:enteBeneficiario>
          <pay_i:identificativoUnivocoBeneficiario>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>$1iuv</pay_i:codiceIdentificativoUnivoco>
          </pay_i:identificativoUnivocoBeneficiario>
          <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
          <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
          <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
          <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
          <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
          <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
          <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
          <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
          <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
      </pay_i:enteBeneficiario>
      <pay_i:datiVersamento>
          <pay_i:dataEsecuzionePagamento>2012-01-16</pay_i:dataEsecuzionePagamento>
          <pay_i:importoTotaleDaVersare>201</pay_i:importoTotaleDaVersare>
          <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
          <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
          <pay_i:codiceContestoPagamento>n/a</pay_i:codiceContestoPagamento>
          <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
          <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
          <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
          <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>101</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>125</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            <!--<pay_i:datiMarcaBolloDigitale> <pay_i:tipoBollo></pay_i:tipoBollo> <pay_i:hashDocumento></pay_i:hashDocumento> <pay_i:provinciaResidenza></pay_i:provinciaResidenza> </datiMarcaBolloDigitale>-->
          </pay_i:datiSingoloVersamento>
      </pay_i:datiVersamento>
    </pay_i:RPT>
    """

  Scenario Outline: Check faultCode PPT_SINTASSI_XSD error on invalid RPT tag
    Given <tag> with <tag_value> in RPT
    And RPT generation
    """
    $RPT
    """
    And initial XML nodoInviaRPT
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
      <soapenv:Header>
          <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
          </ppt:intestazionePPT>
      </soapenv:Header>
      <soapenv:Body>
          <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
          </ws:nodoInviaRPT>
      </soapenv:Body>
    </soapenv:Envelope>
    """

    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SINTASSI_XSD of nodoInviaRPT response
    Examples: 
      | SoapUI    | tag                                     | tag_value                                                                   |
      | RPTSIN1   | pay_i:versioneOggetto                   | None                                                                        |
      | RPTSIN2   | pay_i:versioneOggetto                   | Empty                                                                       |
      | RPTSIN3   | pay_i:versioneOggetto                   | Sono17CaratteAlfa                                                           |
      | RPTSIN4   | pay_i:dominio                           | None                                                                        |
      | RPTSIN5   | pay_i:identificativoDominio             | None                                                                        |
      | RPTSIN6   | pay_i:identificativoDominio             | Empty                                                                       |
      | RPTSIN7   | pay_i:identificativoDominio             | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN8   | pay_i:identificativoStazioneRichiedente | Empty                                                                       |
      | RPTSIN9   | pay_i:identificativoStazioneRichiedente | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN10  | pay_i:identificativoMessaggioRichiesta  | None                                                                        |
      | RPTSIN11  | pay_i:identificativoMessaggioRichiesta  | Empty                                                                       |
      | RPTSIN12  | pay_i:identificativoMessaggioRichiesta  | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN13  | pay_i:dataOraMessaggioRichiesta         | None                                                                        |
      | RPTSIN14  | pay_i:dataOraMessaggioRichiesta         | Empty                                                                       |
      | RPTSIN15  | pay_i:dataOraMessaggioRichiesta         | 2001-12-31T12:00:00:0001                                                    |
      | RPTSIN16  | pay_i:dataOraMessaggioRichiesta         | 2001-12-31T12:00                                                            |
      | RPTSIN17  | pay_i:dataOraMessaggioRichiesta         | 31-12-2001T12:00:00                                                         |
      | RPTSIN18  | pay_i:autenticazioneSoggetto            | None                                                                        |
      | RPTSIN19  | pay_i:autenticazioneSoggetto            | Empty                                                                       |
      | RPTSIN20  | pay_i:autenticazioneSoggetto            | ABS12                                                                       |
      | RPTSIN21  | pay_i:autenticazioneSoggetto            | USP                                                                         |
      | RPTSIN22  | pay_i:soggettoVersante                  | RemoveParent                                                                |
      | RPTSIN23  | pay_i:identificativoUnivocoVersante     | None                                                                        |
      | RPTSIN24  | pay_i:identificativoUnivocoVersante     | RemoveParent                                                                |
      | RPTSIN25  | pay_i:tipoIdentificativoUnivoco         | None                                                                        |
      | RPTSIN26  | pay_i:tipoIdentificativoUnivoco         | Empty                                                                       |
      | RPTSIN27  | pay_i:tipoIdentificativoUnivoco         | PP                                                                          |
      | RPTSIN28  | pay_i:tipoIdentificativoUnivoco         | A                                                                           |
      | RPTSIN29  | pay_i:codiceIdentificativoUnivoco       | None                                                                        |
      | RPTSIN30  | pay_i:codiceIdentificativoUnivoco       | Empty                                                                       |
      | RPTSIN31  | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN32  | pay_i:anagraficaVersante                | None                                                                        |
      | RPTSIN33  | pay_i:anagraficaVersante                | Empty                                                                       |
      | RPTSIN34  | pay_i:anagraficaVersante                | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345     |
      | RPTSIN35  | pay_i:indirizzoVersante                 | Empty                                                                       |
      | RPTSIN36  | pay_i:indirizzoVersante                 | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345     |
      | RPTSIN37  | pay_i:civicoVersante                    | Empty                                                                       |
      | RPTSIN37.1| pay_i:civicoVersante                    | None                                                                        |
      | RPTSIN38  | pay_i:civicoVersante                    | Sono17CaratteAlfa                                                           |
      | RPTSIN39  | pay_i:capVersante                       | Empty                                                                       |
      | RPTSIN39.1| pay_i:capVersante                       | None                                                                        |
      | RPTSIN40  | pay_i:capVersante                       | Sono17CaratteAlfa                                                           |
      | RPTSIN41  | pay_i:localitaVersante                  | Empty                                                                       |
      | RPTSIN41.1| pay_i:localitaVersante                  | None                                                                        |
      | RPTSIN42  | pay_i:localitaVersante                  | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN43  | pay_i:provinciaVersante                 | Empty                                                                       |
      | RPTSIN43.1| pay_i:provinciaVersante                 | None                                                                        |
      | RPTSIN44  | pay_i:provinciaVersante                 | MIprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersanteprovinciaVersante |
      | RPTSIN45  | pay_i:nazioneVersante                   | Empty                                                                       |
      | RPTSIN45.1| pay_i:nazioneVersante                   | None                                                                        |
      | RPTSIN46  | pay_i:nazioneVersante                   | AB1                                                                         |
      | RPTSIN47  | pay_i:e-mailVersante                    | Empty                                                                       |
      | RPTSIN47.1| pay_i:e-mailVersante                    | None                                                                        |
      | RPTSIN48  | pay_i:e-mailVersante                    | 257DDDDDDDDDDDDDDDDDDDDDDDDDFFFFFFFFFFFFFFDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFDDDmail |
      | RPTSIN49  | pay_i:soggettoPagatore                  | None                                                                        |
      | RPTSIN50  | pay_i:soggettoPagatore                  | RemoveParent                                                                |
      | RPTSIN51  | pay_i:identificativoUnivocoPagatore     | None                                                                        |
      | RPTSIN52  | pay_i:identificativoUnivocoPagatore     | RemoveParent                                                                |
      | RPTSIN53  | pay_i:tipoIdentificativoUnivoco         | None                                                                        |
      | RPTSIN54  | pay_i:tipoIdentificativoUnivoco         | Empty                                                                       |
      | RPTSIN55  | pay_i:tipoIdentificativoUnivoco         | FF                                                                          |
      | RPTSIN56  | pay_i:tipoIdentificativoUnivoco         | H                                                                           |
      | RPTSIN57  | pay_i:codiceIdentificativoUnivoco       | None                                                                        |
      | RPTSIN58  | pay_i:codiceIdentificativoUnivoco       | Empty                                                                       |
      | RPTSIN59  | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN60  | pay_i:anagraficaPagatore                | None                                                                        |
      | RPTSIN61  | pay_i:anagraficaPagatore                | Empty                                                                       |
      | RPTSIN62  | pay_i:anagraficaPagatore                | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345     |
      | RPTSIN63  | pay_i:indirizzoPagatore                 | Empty                                                                       |
      | RPTSIN63.1| pay_i:indirizzoPagatore                 | None                                                                        |
      | RPTSIN64  | pay_i:indirizzoPagatore                 | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345     |
      | RPTSIN65  | pay_i:civicoPagatore                    | Empty                                                                       |
      | RPTSIN65.1| pay_i:civicoPagatore                    | None                                                                        |
      | RPTSIN66  | pay_i:civicoPagatore                    | Sono17CaratteAlfa                                                           |
      | RPTSIN67  | pay_i:capPagatore                       | Empty                                                                       |         
      | RPTSIN67.1| pay_i:capPagatore                       | None                                                                        |
      | RPTSIN68  | pay_i:capPagatore                       | Sono17CaratteAlfa                                                           |
      | RPTSIN69  | pay_i:localitaPagatore                  | Empty                                                                       |
      | RPTSIN69.1| pay_i:localitaPagatore                  | None                                                                        |
      | RPTSIN70  | pay_i:localitaPagatore                  | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN71  | pay_i:provinciaPagatore                 | Empty                                                                       |
      | RPTSIN71.1| pay_i:provinciaPagatore                 | None                                                                        |
      | RPTSIN72  | pay_i:provinciaPagatore                 | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN73  | pay_i:nazionePagatore                   | Empty                                                                       |
      | RPTSIN73.1| pay_i:nazionePagatore                   | None                                                                        |
      | RPTSIN74  | pay_i:nazionePagatore                   | AB1                                                                         |
      | RPTSIN75  | pay_i:e-mailPagatore                    | Empty                                                                       |
      | RPTSIN75.1| pay_i:e-mailPagatore                    | None                                                                        |
      | RPTSIN76  | pay_i:e-mailPagatore                    | 257DDDDDDDDDDDDDDDDDDDDDDDDDFFFFFFFFFFFFFFDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFDDDmail |
      | RPTSIN77  | pay_i:enteBeneficiario                  | None                                                                        |
      | RPTSIN78  | pay_i:enteBeneficiario                  | RemoveParent                                                                |
      | RPTSIN79  | pay_i:identificativoUnivocoBeneficiario | None                                                                        |
      | RPTSIN80  | pay_i:identificativoUnivocoBeneficiario | RemoveParent                                                                |
      | RPTSIN81  | pay_i:tipoIdentificativoUnivoco         | None                                                                        |
      | RPTSIN82  | pay_i:tipoIdentificativoUnivoco         | Empty                                                                       |
      | RPTSIN83  | pay_i:tipoIdentificativoUnivoco         | GG                                                                          |
      | RPTSIN84  | pay_i:tipoIdentificativoUnivoco         | C                                                                           |
      | RPTSIN85  | pay_i:codiceIdentificativoUnivoco       | None                                                                        |
      | RPTSIN86  | pay_i:codiceIdentificativoUnivoco       | Empty                                                                       |
      | RPTSIN87  | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN88  | pay_i:denominazioneBeneficiario         | None                                                                        |
      | RPTSIN89  | pay_i:denominazioneBeneficiario         | Empty                                                                       |
      | RPTSIN90  | pay_i:denominazioneBeneficiario         | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345     |
      | RPTSIN91  | pay_i:codiceUnitOperBeneficiario        | Empty                                                                       |
      | RPTSIN91.1| pay_i:codiceUnitOperBeneficiario        | None                                                                        |
      | RPTSIN92  | pay_i:codiceUnitOperBeneficiario        | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN93  | pay_i:denomUnitOperBeneficiario         | Empty                                                                       |
      | RPTSIN93.1| pay_i:denomUnitOperBeneficiario         | None                                                                        |
      | RPTSIN94  | pay_i:denomUnitOperBeneficiario         | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345     |
      | RPTSIN95  | pay_i:indirizzoBeneficiario             | Empty                                                                       |
      | RPTSIN95.1| pay_i:indirizzoBeneficiario             | None                                                                        |
      | RPTSIN96  | pay_i:indirizzoBeneficiario             | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345     |
      | RPTSIN97  | pay_i:civicoBeneficiario                | Empty                                                                       |
      | RPTSIN97.1| pay_i:civicoBeneficiario                | None                                                                        |
      | RPTSIN98  | pay_i:civicoBeneficiario                | Sono17CaratteAlfa                                                           |
      | RPTSIN99  | pay_i:capBeneficiario                   | Empty                                                                       |
      | RPTSIN99.1| pay_i:capBeneficiario                   | None                                                                        |
      | RPTSIN100 | pay_i:capBeneficiario                   | Sono17CaratteAlfa                                                           |
      | RPTSIN101  | pay_i:capBeneficiario                  | Empty                                                                       |
      | RPTSIN101.1| pay_i:capBeneficiario                  | None                                                                        |
      | RPTSIN102  | pay_i:capBeneficiario                  | Sono17CaratteAlfa                                                           |
      | RPTSIN103  | pay_i:provinciaBeneficiario            | Empty                                                                       |
      | RPTSIN103.1| pay_i:provinciaBeneficiario            | None                                                                        |
      | RPTSIN104  | pay_i:provinciaBeneficiario            | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN105  | pay_i:nazioneBeneficiario              | Empty                                                                       |
      | RPTSIN105.1| pay_i:nazioneBeneficiario              | None                                                                        |
      | RPTSIN106  | pay_i:nazioneBeneficiario              | AB1                                                                         |
      | RPTSIN107  | pay_i:datiVersamento                   | None                                                                        |
      | RPTSIN108  | pay_i:datiVersamento                   | RemoveParent                                                                |
      | RPTSIN109  | pay_i:dataEsecuzionePagamento          | None                                                                        |
      | RPTSIN110  | pay_i:dataEsecuzionePagamento          | Empty                                                                       |
      | RPTSIN111  | pay_i:dataEsecuzionePagamento          | 2001-12-31T12:00                                                            |
      | RPTSIN112  | pay_i:dataEsecuzionePagamento          | 2001-12-                                                                    |
      | RPTSIN113  | pay_i:importoTotaleDaVersare           | None                                                                        |
      | RPTSIN114  | pay_i:importoTotaleDaVersare           | Empty                                                                       |
      | RPTSIN115  | pay_i:importoTotaleDaVersare           | 22                                                                          |
      | RPTSIN116  | pay_i:importoTotaleDaVersare           | 0.00                                                                        |
      | RPTSIN117  | pay_i:importoTotaleDaVersare           | 199999999.99                                                                |
      | RPTSIN118  | pay_i:importoTotaleDaVersare           | 10.251                                                                      |
      | RPTSIN119  | pay_i:importoTotaleDaVersare           | 10,25                                                                       |
      | RPTSIN120  | pay_i:tipoVersamento                   | None                                                                        |
      | RPTSIN121  | pay_i:tipoVersamento                   | Empty                                                                       |
      | RPTSIN122  | pay_i:tipoVersamento                   | OBEPT                                                                       |
      | RPTSIN123  | pay_i:tipoVersamento                   | BD                                                                          |
      | RPTSIN124  | pay_i:identificativoUnivocoVersamento  | None                                                                        |
      | RPTSIN125  | pay_i:identificativoUnivocoVersamento  | Empty                                                                       |
      | RPTSIN126  | pay_i:identificativoUnivocoVersamento  | QuestiSono36CaratteriAlfaNumericiTT1                                        |
      | RPTSIN127  | pay_i:codiceContestoPagamento          | None                                                                        |
      | RPTSIN128  | pay_i:codiceContestoPagamento          | Empty                                                                       |
      | RPTSIN129  | pay_i:codiceContestoPagamento          | QuestiSono36CaratteriAlfaNumericiTT1                                        |