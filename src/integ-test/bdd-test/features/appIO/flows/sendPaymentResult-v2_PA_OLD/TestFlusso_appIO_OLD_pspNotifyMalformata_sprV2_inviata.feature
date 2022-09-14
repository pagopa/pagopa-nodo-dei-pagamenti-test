Feature:  flow check for sendPaymentResult-v2 request - pagamento con appIO diverso da BPAY e PPAL, pspNotifyRes malformata, spr-v2 inviata [T_SPR_V2_17]

    Background:
        Given systems up
        And EC old version

    # nodoVerificaRPT phase
    Scenario: Execute nodoVerificaRPT request
        Given initial XML nodoVerificaRPT soap-request

            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoVerificaRPT>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>#ccp#</codiceContestoPagamento>
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT><qrc:QrCode>  <qrc:CF>#creditor_institution_code#</qrc:CF> <qrc:CodStazPA>02</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>#iuv#</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
            </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        And initial xml paaVerificaRPT
            """"
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
            <paaVerificaRPTRisposta>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>1.00</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>77777777777_05</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>f6</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>r6</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>yr</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaVerificaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>ut</pag:civicoBeneficiario>
            <pag:capBeneficiario>jyr</pag:capBeneficiario>
            <pag:localitaBeneficiario>yj</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>h8</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>IT</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>of8</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/018431538193400/TESTO/causale del versamento</causaleVersamento>
            </datiPagamentoPA>
            </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoVerificaRPT response

    # nodoAttivaRPT phase
    Scenario: Execute nodoAttivaRPT request
        Given the Execute nodoVerificaRPT request scenario executed successfully
        And initial xml nodoAttivaRPT

            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoAttivaRPT>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>$nodoVerificaRPT.ccp</codiceContestoPagamento>
            <identificativoIntermediarioPSPPagamento>#broker_AGID#</identificativoIntermediarioPSPPagamento>
            <identificativoCanalePagamento>97735020584_02</identificativoCanalePagamento>
            <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
            <codiceIdRPT><aim:aim128> <aim:CCPost>#creditor_institution_code#</aim:CCPost> <aim:CodStazPA>02</aim:CodStazPA> <aim:AuxDigit>0</aim:AuxDigit>  <aim:CodIUV>$nodoVerificaRPT.iuv</aim:CodIUV></aim:aim128></codiceIdRPT>
            <datiPagamentoPSP>
            <importoSingoloVersamento>10.00</importoSingoloVersamento>
            <!--Optional:-->
            <ibanAppoggio>IT96R0123454321000000012345</ibanAppoggio>
            <!--Optional:-->
            <bicAppoggio>CCRTIT5TXXX</bicAppoggio>
            <!--Optional:-->
            <soggettoVersante>
            <pag:identificativoUnivocoVersante>
            <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoVersante>
            <pag:anagraficaVersante>Franco Rossi</pag:anagraficaVersante>
            <!--Optional:-->
            <pag:indirizzoVersante>viale Monza</pag:indirizzoVersante>
            <!--Optional:-->
            <pag:civicoVersante>1</pag:civicoVersante>
            <!--Optional:-->
            <pag:capVersante>20125</pag:capVersante>
            <!--Optional:-->
            <pag:localitaVersante>Milano</pag:localitaVersante>
            <!--Optional:-->
            <pag:provinciaVersante>MI</pag:provinciaVersante>
            <!--Optional:-->
            <pag:nazioneVersante>IT</pag:nazioneVersante>
            <!--Optional:-->
            <pag:e-mailVersante>mail@mail.it</pag:e-mailVersante>
            </soggettoVersante>
            <!--Optional:-->
            <ibanAddebito>IT96R0123454321000000012346</ibanAddebito>
            <!--Optional:-->
            <bicAddebito>CCRTIT2TXXX</bicAddebito>
            <!--Optional:-->
            <soggettoPagatore>
            <pag:identificativoUnivocoPagatore>
            <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoPagatore>
            <pag:anagraficaPagatore>Franco Rossi</pag:anagraficaPagatore>
            <!--Optional:-->
            <pag:indirizzoPagatore>viale Monza</pag:indirizzoPagatore>
            <!--Optional:-->
            <pag:civicoPagatore>1</pag:civicoPagatore>
            <!--Optional:-->
            <pag:capPagatore>20125</pag:capPagatore>
            <!--Optional:-->
            <pag:localitaPagatore>Milano</pag:localitaPagatore>
            <!--Optional:-->
            <pag:provinciaPagatore>MI</pag:provinciaPagatore>
            <!--Optional:-->
            <pag:nazionePagatore>IT</pag:nazionePagatore>
            <!--Optional:-->
            <pag:e-mailPagatore>mail@mail.it</pag:e-mailPagatore>
            </soggettoPagatore>
            </datiPagamentoPSP>
            </ws:nodoAttivaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        And initial xml paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
            <paaAttivaRPTRisposta>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>10.00</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>77777777777_05</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>97735020584</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>97735020584_02</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaAttivaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
            <pag:capBeneficiario>gt</pag:capBeneficiario>
            <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>i</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/018431538193400/TXT/causale 109611630410955</causaleVersamento>
            </datiPagamentoPA>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoAttivaRPT response
        And save nodoAttivaRPT response in nodoAttivaRPTResponse

    # nodoInviaRPT phase
    Scenario: Execute nodoInviaRPT request
        Given the Execute nodoAttivaRPT request scenario executed successfully
        And initial XML nodoInviaRPT soap-request

            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#creditor_institution_code#_05</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$nodoVerificaRPT.iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$nodoVerificaRPT.ccp</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>97735020584_02</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>PHBheV9pOlJQVCB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gUGFnSW5mX1JQVF9SVF82XzBfMS54c2QgIiB4bWxuczpwYXlfaT0iaHR0cDovL3d3dy5kaWdpdHBhLmdvdi5pdC9zY2hlbWFzLzIwMTEvUGFnYW1lbnRpLyIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSI+PHBheV9pOnZlcnNpb25lT2dnZXR0bz4xLjA8L3BheV9pOnZlcnNpb25lT2dnZXR0bz48cGF5X2k6ZG9taW5pbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Eb21pbmlvPjc3Nzc3Nzc3Nzc3PC9wYXlfaTppZGVudGlmaWNhdGl2b0RvbWluaW8+PHBheV9pOmlkZW50aWZpY2F0aXZvU3RhemlvbmVSaWNoaWVkZW50ZT43Nzc3Nzc3Nzc3N18wMTwvcGF5X2k6aWRlbnRpZmljYXRpdm9TdGF6aW9uZVJpY2hpZWRlbnRlPjwvcGF5X2k6ZG9taW5pbz48cGF5X2k6aWRlbnRpZmljYXRpdm9NZXNzYWdnaW9SaWNoaWVzdGE+TVNHUklDSElFU1RBMDE8L3BheV9pOmlkZW50aWZpY2F0aXZvTWVzc2FnZ2lvUmljaGllc3RhPjxwYXlfaTpkYXRhT3JhTWVzc2FnZ2lvUmljaGllc3RhPjIwMTYtMDktMTZUMTE6MjQ6MTA8L3BheV9pOmRhdGFPcmFNZXNzYWdnaW9SaWNoaWVzdGE+PHBheV9pOmF1dGVudGljYXppb25lU29nZ2V0dG8+Q05TPC9wYXlfaTphdXRlbnRpY2F6aW9uZVNvZ2dldHRvPjxwYXlfaTpzb2dnZXR0b1ZlcnNhbnRlPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW50ZT48cGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz5GPC9wYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPjxwYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+UkNDR0xEMDlQMDlINTAyRTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FudGU+PHBheV9pOmFuYWdyYWZpY2FWZXJzYW50ZT5HZXN1YWxkbztSaWNjaXRlbGxpPC9wYXlfaTphbmFncmFmaWNhVmVyc2FudGU+PHBheV9pOmluZGlyaXp6b1ZlcnNhbnRlPnZpYSBkZWwgZ2VzdTwvcGF5X2k6aW5kaXJpenpvVmVyc2FudGU+PHBheV9pOmNpdmljb1ZlcnNhbnRlPjExPC9wYXlfaTpjaXZpY29WZXJzYW50ZT48cGF5X2k6Y2FwVmVyc2FudGU+MDAxODY8L3BheV9pOmNhcFZlcnNhbnRlPjxwYXlfaTpsb2NhbGl0YVZlcnNhbnRlPlJvbWE8L3BheV9pOmxvY2FsaXRhVmVyc2FudGU+PHBheV9pOnByb3ZpbmNpYVZlcnNhbnRlPlJNPC9wYXlfaTpwcm92aW5jaWFWZXJzYW50ZT48cGF5X2k6bmF6aW9uZVZlcnNhbnRlPklUPC9wYXlfaTpuYXppb25lVmVyc2FudGU+PHBheV9pOmUtbWFpbFZlcnNhbnRlPmdlc3VhbGRvLnJpY2NpdGVsbGlAcG9zdGUuaXQ8L3BheV9pOmUtbWFpbFZlcnNhbnRlPjwvcGF5X2k6c29nZ2V0dG9WZXJzYW50ZT48cGF5X2k6c29nZ2V0dG9QYWdhdG9yZT48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUGFnYXRvcmU+PHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RjwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz48cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPlJDQ0dMRDA5UDA5SDUwMUU8L3BheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz48L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1BhZ2F0b3JlPjxwYXlfaTphbmFncmFmaWNhUGFnYXRvcmU+R2VzdWFsZG87UmljY2l0ZWxsaTwvcGF5X2k6YW5hZ3JhZmljYVBhZ2F0b3JlPjxwYXlfaTppbmRpcml6em9QYWdhdG9yZT52aWEgZGVsIGdlc3U8L3BheV9pOmluZGlyaXp6b1BhZ2F0b3JlPjxwYXlfaTpjaXZpY29QYWdhdG9yZT4xMTwvcGF5X2k6Y2l2aWNvUGFnYXRvcmU+PHBheV9pOmNhcFBhZ2F0b3JlPjAwMTg2PC9wYXlfaTpjYXBQYWdhdG9yZT48cGF5X2k6bG9jYWxpdGFQYWdhdG9yZT5Sb21hPC9wYXlfaTpsb2NhbGl0YVBhZ2F0b3JlPjxwYXlfaTpwcm92aW5jaWFQYWdhdG9yZT5STTwvcGF5X2k6cHJvdmluY2lhUGFnYXRvcmU+PHBheV9pOm5hemlvbmVQYWdhdG9yZT5JVDwvcGF5X2k6bmF6aW9uZVBhZ2F0b3JlPjxwYXlfaTplLW1haWxQYWdhdG9yZT5nZXN1YWxkby5yaWNjaXRlbGxpQHBvc3RlLml0PC9wYXlfaTplLW1haWxQYWdhdG9yZT48L3BheV9pOnNvZ2dldHRvUGFnYXRvcmU+PHBheV9pOmVudGVCZW5lZmljaWFyaW8+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb0JlbmVmaWNpYXJpbz48cGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz5HPC9wYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPjxwYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+MTExMTExMTExMTc8L3BheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz48L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb0JlbmVmaWNpYXJpbz48cGF5X2k6ZGVub21pbmF6aW9uZUJlbmVmaWNpYXJpbz5BWklFTkRBIFhYWDwvcGF5X2k6ZGVub21pbmF6aW9uZUJlbmVmaWNpYXJpbz48cGF5X2k6Y29kaWNlVW5pdE9wZXJCZW5lZmljaWFyaW8+MTIzPC9wYXlfaTpjb2RpY2VVbml0T3BlckJlbmVmaWNpYXJpbz48cGF5X2k6ZGVub21Vbml0T3BlckJlbmVmaWNpYXJpbz5YWFg8L3BheV9pOmRlbm9tVW5pdE9wZXJCZW5lZmljaWFyaW8+PHBheV9pOmluZGlyaXp6b0JlbmVmaWNpYXJpbz5JbmRpcml6em9CZW5lZmljaWFyaW88L3BheV9pOmluZGlyaXp6b0JlbmVmaWNpYXJpbz48cGF5X2k6Y2l2aWNvQmVuZWZpY2lhcmlvPjEyMzwvcGF5X2k6Y2l2aWNvQmVuZWZpY2lhcmlvPjxwYXlfaTpjYXBCZW5lZmljaWFyaW8+MjIyMjI8L3BheV9pOmNhcEJlbmVmaWNpYXJpbz48cGF5X2k6bG9jYWxpdGFCZW5lZmljaWFyaW8+Um9tYTwvcGF5X2k6bG9jYWxpdGFCZW5lZmljaWFyaW8+PHBheV9pOnByb3ZpbmNpYUJlbmVmaWNpYXJpbz5STTwvcGF5X2k6cHJvdmluY2lhQmVuZWZpY2lhcmlvPjxwYXlfaTpuYXppb25lQmVuZWZpY2lhcmlvPklUPC9wYXlfaTpuYXppb25lQmVuZWZpY2lhcmlvPjwvcGF5X2k6ZW50ZUJlbmVmaWNpYXJpbz48cGF5X2k6ZGF0aVZlcnNhbWVudG8+PHBheV9pOmRhdGFFc2VjdXppb25lUGFnYW1lbnRvPjIwMTYtMDktMTY8L3BheV9pOmRhdGFFc2VjdXppb25lUGFnYW1lbnRvPjxwYXlfaTppbXBvcnRvVG90YWxlRGFWZXJzYXJlPjEwLjAwPC9wYXlfaTppbXBvcnRvVG90YWxlRGFWZXJzYXJlPjxwYXlfaTp0aXBvVmVyc2FtZW50bz5QTzwvcGF5X2k6dGlwb1ZlcnNhbWVudG8+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+MTE5MjIxMDEzMjE5MDE4PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW1lbnRvPjxwYXlfaTpjb2RpY2VDb250ZXN0b1BhZ2FtZW50bz4xNzA0NjE1OTY0MTA3NjU8L3BheV9pOmNvZGljZUNvbnRlc3RvUGFnYW1lbnRvPjxwYXlfaTppYmFuQWRkZWJpdG8+SVQ5NlIwMTIzNDU0MzIxMDAwMDAwMDEyMzQ1PC9wYXlfaTppYmFuQWRkZWJpdG8+PHBheV9pOmJpY0FkZGViaXRvPkFSVElJVE0xMDQ1PC9wYXlfaTpiaWNBZGRlYml0bz48cGF5X2k6ZmlybWFSaWNldnV0YT4wPC9wYXlfaTpmaXJtYVJpY2V2dXRhPjxwYXlfaTpkYXRpU2luZ29sb1ZlcnNhbWVudG8+PHBheV9pOmltcG9ydG9TaW5nb2xvVmVyc2FtZW50bz4xMC4wMDwvcGF5X2k6aW1wb3J0b1NpbmdvbG9WZXJzYW1lbnRvPjxwYXlfaTpjb21taXNzaW9uZUNhcmljb1BBPjEuMDA8L3BheV9pOmNvbW1pc3Npb25lQ2FyaWNvUEE+PHBheV9pOmliYW5BY2NyZWRpdG8+SVQ5NlIwMTIzNDU0MzIxMDAwMDAwMDEyMzQ1PC9wYXlfaTppYmFuQWNjcmVkaXRvPjxwYXlfaTpiaWNBY2NyZWRpdG8+QVJUSUlUTTEwNTA8L3BheV9pOmJpY0FjY3JlZGl0bz48cGF5X2k6aWJhbkFwcG9nZ2lvPklUOTZSMDEyMzQ1MTIzNDUxMjM0NTY3ODkwNDwvcGF5X2k6aWJhbkFwcG9nZ2lvPjxwYXlfaTpiaWNBcHBvZ2dpbz5BUlRJSVRNMTA1MDwvcGF5X2k6YmljQXBwb2dnaW8+PHBheV9pOmNyZWRlbnppYWxpUGFnYXRvcmU+Q1AxLjE8L3BheV9pOmNyZWRlbnppYWxpUGFnYXRvcmU+PHBheV9pOmNhdXNhbGVWZXJzYW1lbnRvPnBhZ2FtZW50byBmb3RvY29waWUgcHJhdGljYTwvcGF5X2k6Y2F1c2FsZVZlcnNhbWVudG8+PHBheV9pOmRhdGlTcGVjaWZpY2lSaXNjb3NzaW9uZT4xL2FiYzwvcGF5X2k6ZGF0aVNwZWNpZmljaVJpc2Nvc3Npb25lPjwvcGF5X2k6ZGF0aVNpbmdvbG9WZXJzYW1lbnRvPjwvcGF5X2k6ZGF0aVZlcnNhbWVudG8+PC9wYXlfaTpSUFQ+</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response


    # nodoChiediInformazioniPagamento phase
    Scenario: Execute a nodoChiediInformazioniPagamento request
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$idSessione to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200


    # closePayment-v2 phase
    Scenario: Execute a closePayment-v2 request
        Given the Execute a nodoChiediInformazioniPagamento request scenario executed successfully
        And initial json closePayment-v2
            """
            {
                "paymentTokens": [
                    "$idSessione"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "60000000001_03",
                "paymentMethod": "TPAY",
                "transactionId": "19392562",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "10793459"
                }
            }
            """
        And initial xml pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:psp="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <psp:pspNotifyPaymentRes>
            <outcome>OO</outcome>
            </psp:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
        When PM sends closePayment-v2 to nodo-dei-pagamenti
        Then check outcome is OK of closePayment-v2
        And verify the HTTP status code of closePayment-v2 response is 200


    # sendPaymentOutcome phase
    Scenario: Execute sendPaymentOutcome request
        Given the Execute a closePayment-v2 request scenario executed successfully
        And initial xml sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>60000000001</idBrokerPSP>
            <idChannel>#canale_IMMEDIATO_MULTIBENEFICIARIO#</idChannel>
            <password>pwdpwdpwd</password>
            <paymentToken>$nodoVerificaRPT.ccp</paymentToken>
            <outcome>OK</outcome>
            <!--Optional:-->
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>SPOname_$nodoVerificaRPT.ccp</fullName>
            <!--Optional:-->
            <streetName>SPOstreet</streetName>
            <!--Optional:-->
            <civicNumber>SPOcivic</civicNumber>
            <!--Optional:-->
            <postalCode>SPOpostal</postalCode>
            <!--Optional:-->
            <city>SPOcity</city>
            <!--Optional:-->
            <stateProvinceRegion>SPOstate</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>SPOprova@test.it</e-mail>
            </payer>
            <applicationDate>2021-12-12</applicationDate>
            <transferDate>2021-12-11</transferDate>
            </details>
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And wait 10 seconds for expiration
        When psp sends sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

# check db
# Scenario: DB check1
#Given the Execute sendPaymentOutcome request scenario executed successfully
#Then verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
#And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
#And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO

# implementare gli altri DB check sugli stati e i check su RE per verificare che la sendPaymentResultV2 sia inviata
