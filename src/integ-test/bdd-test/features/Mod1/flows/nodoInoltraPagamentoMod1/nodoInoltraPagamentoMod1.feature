Feature: process tests for nodoInoltraPagamentoMod1

    Background:
        Given systems up

    Scenario: RPT generation
        Given RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
            <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco>
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
            <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoBeneficiario>
            <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
            <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
            <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
            <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
            <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
            <pay_i:capBeneficiario>22222</pay_i:capBeneficiario>
            <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
            <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
            <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
            <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>6.20</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>#IUV#</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>6.20</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """

    Scenario: Execute nodoInviaRPT request
        Given the RPT generation scenario executed successfully
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML pspInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspInviaRPTResponse>
            <pspInviaRPTResponse>
            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
            <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
            <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
            </pspInviaRPTResponse>
            </ws:pspInviaRPTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_1
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Richiesta non valida of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_2
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is Il Pagamento indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_3
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "tCase#idPagamento}",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is Il Pagamento indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_4
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Richiesta non valida of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_5
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is Il PSP indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_6
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "se#identificativoPSP}",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is Il PSP indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_7
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "NOT_ENABLED",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is Il PSP indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_8
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "PO",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 422
        And check error is Tipo Versamento invalido of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_8.1
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_8.2
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "AD",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 422
        And check error is Tipo Versamento invalido of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_8.3
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "OTH",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Richiesta non valida of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_8.4
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "OBEP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_8.5
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_8.6
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_9
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Richiesta non valida of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_10
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Richiesta non valida of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_11
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "bbt",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Richiesta non valida of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_12
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "PIPPO",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Richiesta non valida of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_13
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Richiesta non valida of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_14
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is L'Intermediario indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_15
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "sconosciuto",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is L'Intermediario indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_16
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "INT_NOT_ENABLED",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is L'Intermediario indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_17
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Richiesta non valida of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_18
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is Il Canale indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_19
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "sconosciuto",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is Il Canale indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_20
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "NOT_ENABLED",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is Il Canale indicato non esiste of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_21
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "97735020584_03",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 404
        And check error is Configurazione intermediario-canale non corretta of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_22
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 422
        And check error is Tipo Operazione invalido of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_23
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "web",
                "mobileToken": "987654"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_24
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 422
        And check error is Mobile Token invalido of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_25
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": ""
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 422
        And check error is Tipo Operazione invalido of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_26
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": ""
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_27
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "identificativoPsp": "#psp#",
                "idPagamento": "$sessionToken",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "web"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200

    # @runnable @independent
    # Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_28
    #     Given the Execute nodoInviaRPT request scenario executed successfully
    #     When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
    #         """
    #         {
    #         "idPagamento":"$sessionToken",
    #         "identificativoPsp":,
    #         "tipoVersamento":"BBT",
    #         "identificativoIntermediario":"#psp#",
    #         "identificativoCanale": "#canale#",
    #         "tipoOperazione":"web"
    #         }
    #         """
    #     Then verify the HTTP status code of inoltroEsito/mod1 response is 422
    #     And check error is Tipo Operazione invalido of inoltroEsito/mod1 response

    @runnable @independent
    Scenario: execution nodoInoltraPagamentoMod1 - PM_IPM1_29
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale_DIFFERITO_MOD2#",
                "tipoOperazione": "mobile",
                "mobileToken": ""
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 400
        And check error is Modello pagamento non valido of inoltroEsito/mod1 response






