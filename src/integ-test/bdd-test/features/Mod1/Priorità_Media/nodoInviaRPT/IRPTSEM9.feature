Feature: process tests for nodoInviaRT[IRPTSEM9]
    Background:
        Given systems up

    Scenario: RPT generation
        Given RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>44444444444</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>44444444444_01</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>#iuv2#</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>0/abc</pay_i:datiSpecificiRiscossione>
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
                    <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                    <identificativoDominio>44444444444</identificativoDominio>
                    <identificativoUnivocoVersamento>#iuv2#</identificativoUnivocoVersamento>
                    <codiceContestoPagamento>ccp</codiceContestoPagamento>
                </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
                <ws:nodoInviaRPT>
                    <password>pwdpwdpwd</password>
                    <identificativoPSP>40000000001</identificativoPSP>
                    <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>40000000001_03</identificativoCanale>
                    <tipoFirma></tipoFirma>
                    <rpt>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxwYXlfaTpSUFQgeG1sbnM6cGF5X2k9Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0iaHR0cDovL3d3dy5kaWdpdHBhLmdvdi5pdC9zY2hlbWFzLzIwMTEvUGFnYW1lbnRpLyBQYWdJbmZfUlBUX1JUXzZfMF8xLnhzZCAiPg0KIDwhLS08cGF5X2k6dmVyc2lvbmVPZ2dldHRvPjYuMDwvcGF5X2k6dmVyc2lvbmVPZ2dldHRvPi0tPg0KCTxwYXlfaTpkb21pbmlvPg0KCQk8cGF5X2k6aWRlbnRpZmljYXRpdm9Eb21pbmlvPjgwMTg0NDMwNTg3PC9wYXlfaTppZGVudGlmaWNhdGl2b0RvbWluaW8+DQoJCTxwYXlfaTppZGVudGlmaWNhdGl2b1N0YXppb25lUmljaGllZGVudGU+SURTdGF6aW9uZVJpY2hpZWRlbnRlPC9wYXlfaTppZGVudGlmaWNhdGl2b1N0YXppb25lUmljaGllZGVudGU+DQoJPC9wYXlfaTpkb21pbmlvPg0KCTxwYXlfaTppZGVudGlmaWNhdGl2b01lc3NhZ2dpb1JpY2hpZXN0YT5UT19HRU5FUkFURTwvcGF5X2k6aWRlbnRpZmljYXRpdm9NZXNzYWdnaW9SaWNoaWVzdGE+DQoJPHBheV9pOmRhdGFPcmFNZXNzYWdnaW9SaWNoaWVzdGE+MjAxMi0wMS0xNlQxMToyNDoxMDwvcGF5X2k6ZGF0YU9yYU1lc3NhZ2dpb1JpY2hpZXN0YT4NCgk8cGF5X2k6YXV0ZW50aWNhemlvbmVTb2dnZXR0bz5DTlM8L3BheV9pOmF1dGVudGljYXppb25lU29nZ2V0dG8+DQogIAk8cGF5X2k6c29nZ2V0dG9WZXJzYW50ZT4NCgkJPHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbnRlPg0KCQkJPHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RjwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz4NCgkJCTxwYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+UkNDR0xEMDlQMDlINTAxRTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPg0KCQk8L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbnRlPg0KCQk8cGF5X2k6YW5hZ3JhZmljYVZlcnNhbnRlPkdlc3VhbGRvO1JpY2NpdGVsbGk8L3BheV9pOmFuYWdyYWZpY2FWZXJzYW50ZT4NCgkJPHBheV9pOmluZGlyaXp6b1ZlcnNhbnRlPnZpYSBkZWwgZ2VzdTwvcGF5X2k6aW5kaXJpenpvVmVyc2FudGU+DQoJCTxwYXlfaTpjaXZpY29WZXJzYW50ZT4xMTwvcGF5X2k6Y2l2aWNvVmVyc2FudGU+DQoJCTxwYXlfaTpjYXBWZXJzYW50ZT4wMDE4NjwvcGF5X2k6Y2FwVmVyc2FudGU+DQoJCTxwYXlfaTpsb2NhbGl0YVZlcnNhbnRlPlJvbWE8L3BheV9pOmxvY2FsaXRhVmVyc2FudGU+DQoJCTxwYXlfaTpwcm92aW5jaWFWZXJzYW50ZT5STTwvcGF5X2k6cHJvdmluY2lhVmVyc2FudGU+DQoJCTxwYXlfaTpuYXppb25lVmVyc2FudGU+SVQ8L3BheV9pOm5hemlvbmVWZXJzYW50ZT4NCgkJPHBheV9pOmUtbWFpbFZlcnNhbnRlPmdlc3VhbGRvLnJpY2NpdGVsbGlAcG9zdGUuaXQ8L3BheV9pOmUtbWFpbFZlcnNhbnRlPg0KCTwvcGF5X2k6c29nZ2V0dG9WZXJzYW50ZT4NCgk8cGF5X2k6c29nZ2V0dG9QYWdhdG9yZT4NCgkJPHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1BhZ2F0b3JlPg0KCQkJPHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RjwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz4NCgkJCTxwYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+UkNDR0xEMDlQMDlINTAxRTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPg0KCQk8L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1BhZ2F0b3JlPg0KCQk8cGF5X2k6YW5hZ3JhZmljYVBhZ2F0b3JlPkdlc3VhbGRvO1JpY2NpdGVsbGk8L3BheV9pOmFuYWdyYWZpY2FQYWdhdG9yZT4NCgkJPHBheV9pOmluZGlyaXp6b1BhZ2F0b3JlPnZpYSBkZWwgZ2VzdTwvcGF5X2k6aW5kaXJpenpvUGFnYXRvcmU+DQoJCTxwYXlfaTpjaXZpY29QYWdhdG9yZT4xMTwvcGF5X2k6Y2l2aWNvUGFnYXRvcmU+DQoJCTxwYXlfaTpjYXBQYWdhdG9yZT4wMDE4NjwvcGF5X2k6Y2FwUGFnYXRvcmU+DQoJCTxwYXlfaTpsb2NhbGl0YVBhZ2F0b3JlPlJvbWE8L3BheV9pOmxvY2FsaXRhUGFnYXRvcmU+DQoJCTxwYXlfaTpwcm92aW5jaWFQYWdhdG9yZT5STTwvcGF5X2k6cHJvdmluY2lhUGFnYXRvcmU+DQoJCTxwYXlfaTpuYXppb25lUGFnYXRvcmU+SVQ8L3BheV9pOm5hemlvbmVQYWdhdG9yZT4NCgkJPHBheV9pOmUtbWFpbFBhZ2F0b3JlPmdlc3VhbGRvLnJpY2NpdGVsbGlAcG9zdGUuaXQ8L3BheV9pOmUtbWFpbFBhZ2F0b3JlPg0KCTwvcGF5X2k6c29nZ2V0dG9QYWdhdG9yZT4NCgk8cGF5X2k6ZW50ZUJlbmVmaWNpYXJpbz4NCgkJPHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb0JlbmVmaWNpYXJpbz4NCgkJCTxwYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+DQoJCQk8cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjExMTExMTExMTE3PC9wYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+DQoJCTwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvQmVuZWZpY2lhcmlvPg0KCQk8cGF5X2k6ZGVub21pbmF6aW9uZUJlbmVmaWNpYXJpbz5BWklFTkRBIFhYWDwvcGF5X2k6ZGVub21pbmF6aW9uZUJlbmVmaWNpYXJpbz4NCgkJPHBheV9pOmNvZGljZVVuaXRPcGVyQmVuZWZpY2lhcmlvPjEyMzwvcGF5X2k6Y29kaWNlVW5pdE9wZXJCZW5lZmljaWFyaW8+DQoJCTxwYXlfaTpkZW5vbVVuaXRPcGVyQmVuZWZpY2lhcmlvPlhYWDwvcGF5X2k6ZGVub21Vbml0T3BlckJlbmVmaWNpYXJpbz4NCgkJPHBheV9pOmluZGlyaXp6b0JlbmVmaWNpYXJpbz5JbmRpcml6em9CZW5lZmljaWFyaW88L3BheV9pOmluZGlyaXp6b0JlbmVmaWNpYXJpbz4NCgkJPHBheV9pOmNpdmljb0JlbmVmaWNpYXJpbz4xMjM8L3BheV9pOmNpdmljb0JlbmVmaWNpYXJpbz4NCgkJPHBheV9pOmNhcEJlbmVmaWNpYXJpbz4wMDEyMzwvcGF5X2k6Y2FwQmVuZWZpY2lhcmlvPg0KCQk8cGF5X2k6bG9jYWxpdGFCZW5lZmljaWFyaW8+Um9tYTwvcGF5X2k6bG9jYWxpdGFCZW5lZmljaWFyaW8+DQoJCTxwYXlfaTpwcm92aW5jaWFCZW5lZmljaWFyaW8+Uk08L3BheV9pOnByb3ZpbmNpYUJlbmVmaWNpYXJpbz4NCgkJPHBheV9pOm5hemlvbmVCZW5lZmljaWFyaW8+SVQ8L3BheV9pOm5hemlvbmVCZW5lZmljaWFyaW8+DQoJPC9wYXlfaTplbnRlQmVuZWZpY2lhcmlvPg0KCTxwYXlfaTpkYXRpVmVyc2FtZW50bz4NCgkJPHBheV9pOmRhdGFFc2VjdXppb25lUGFnYW1lbnRvPjIwMTItMDEtMTY8L3BheV9pOmRhdGFFc2VjdXppb25lUGFnYW1lbnRvPg0KCQk8cGF5X2k6aW1wb3J0b1RvdGFsZURhVmVyc2FyZT4yMDE8L3BheV9pOmltcG9ydG9Ub3RhbGVEYVZlcnNhcmU+DQoJCTxwYXlfaTp0aXBvVmVyc2FtZW50bz5CQlQ8L3BheV9pOnRpcG9WZXJzYW1lbnRvPg0KCQk8cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FtZW50bz5UUjAwMDFfMjAxMjAxMTYtMTE6MjQ6MTAuMDUyMS03RUY2PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW1lbnRvPg0KCQk8cGF5X2k6Y29kaWNlQ29udGVzdG9QYWdhbWVudG8+bi9hPC9wYXlfaTpjb2RpY2VDb250ZXN0b1BhZ2FtZW50bz4NCgkJPHBheV9pOmliYW5BZGRlYml0bz5JVDk2UjAxMjM0NTQzMjEwMDAwMDAwMTIzNDU8L3BheV9pOmliYW5BZGRlYml0bz4NCgkJPHBheV9pOmJpY0FkZGViaXRvPkFSVElJVE0xMDQ1PC9wYXlfaTpiaWNBZGRlYml0bz4NCgkJPHBheV9pOmZpcm1hUmljZXZ1dGE+MDwvcGF5X2k6ZmlybWFSaWNldnV0YT4NCgkJPHBheV9pOmRhdGlTaW5nb2xvVmVyc2FtZW50bz4NCgkJCTxwYXlfaTppbXBvcnRvU2luZ29sb1ZlcnNhbWVudG8+MTAxPC9wYXlfaTppbXBvcnRvU2luZ29sb1ZlcnNhbWVudG8+DQoJCQk8cGF5X2k6Y29tbWlzc2lvbmVDYXJpY29QQT4xMjU8L3BheV9pOmNvbW1pc3Npb25lQ2FyaWNvUEE+DQoJCQk8cGF5X2k6aWJhbkFjY3JlZGl0bz5JVDk2UjAxMjM0NTQzMjEwMDAwMDAwMTIzNDU8L3BheV9pOmliYW5BY2NyZWRpdG8+DQoJCQk8cGF5X2k6YmljQWNjcmVkaXRvPkFSVElJVE0xMDUwPC9wYXlfaTpiaWNBY2NyZWRpdG8+DQoJCQk8cGF5X2k6aWJhbkFwcG9nZ2lvPklUOTZSMDEyMzQ1NDMyMTAwMDAwMDAxMjM0NTwvcGF5X2k6aWJhbkFwcG9nZ2lvPg0KCQkJPHBheV9pOmJpY0FwcG9nZ2lvPkFSVElJVE0xMDUwPC9wYXlfaTpiaWNBcHBvZ2dpbz4NCgkJCTxwYXlfaTpjcmVkZW56aWFsaVBhZ2F0b3JlPkNQMS4xPC9wYXlfaTpjcmVkZW56aWFsaVBhZ2F0b3JlPg0KCQkJPHBheV9pOmNhdXNhbGVWZXJzYW1lbnRvPnBhZ2FtZW50byBmb3RvY29waWUgcHJhdGljYTwvcGF5X2k6Y2F1c2FsZVZlcnNhbWVudG8+DQoJCQk8cGF5X2k6ZGF0aVNwZWNpZmljaVJpc2Nvc3Npb25lPjEvYWJjPC9wYXlfaTpkYXRpU3BlY2lmaWNpUmlzY29zc2lvbmU+DQoJCQk8IS0tPHBheV9pOmRhdGlNYXJjYUJvbGxvRGlnaXRhbGU+DQoJCQkJPHBheV9pOnRpcG9Cb2xsbz48L3BheV9pOnRpcG9Cb2xsbz4NCgkJCQk8cGF5X2k6aGFzaERvY3VtZW50bz48L3BheV9pOmhhc2hEb2N1bWVudG8+DQoJCQkJPHBheV9pOnByb3ZpbmNpYVJlc2lkZW56YT48L3BheV9pOnByb3ZpbmNpYVJlc2lkZW56YT4NCgkJCTwvZGF0aU1hcmNhQm9sbG9EaWdpdGFsZT4tLT4NCgkJPC9wYXlfaTpkYXRpU2luZ29sb1ZlcnNhbWVudG8+DQoJPC9wYXlfaTpkYXRpVmVyc2FtZW50bz4NCjwvcGF5X2k6UlBUPg==</rpt>
                </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
            When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
            Then check esito is KO of nodoInviaRPT response
            And check faultCode is PPT_SEMANTICA of nodoInviaRPT response