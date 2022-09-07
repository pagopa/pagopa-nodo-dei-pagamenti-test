Feature: process tests for nodoInviaRPT [REV_NIRPT_07]

   Background:
      Given systems up
      And EC old version
      And initial XML verifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:verifyPaymentNoticeReq>
         <idPSP>40000000001</idPSP>
         <idBrokerPSP>40000000001</idBrokerPSP>
         <idChannel>40000000001_01</idChannel>
         <password>pwdpwdpwd</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code_old#</fiscalCode>
         <noticeNumber>#notice_number_old#</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>

         """

   # Verify phase
   Scenario: Execute verifyPaymentNotice request
      When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response

   Scenario: Execute activatePaymentNotice request
      Given the Execute verifyPaymentNotice request scenario executed successfully
      And initial XML activatePaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activatePaymentNoticeReq>
         <idPSP>40000000001</idPSP>
         <idBrokerPSP>40000000001</idBrokerPSP>
         <idChannel>40000000001_01</idChannel>
         <password>pwdpwdpwd</password>
         <idempotencyKey>40000000001_182704dwBR</idempotencyKey>
         <qrCode>
         <fiscalCode>#creditor_institution_code_old#</fiscalCode>
         <noticeNumber>#notice_number_old#</noticeNumber>
         </qrCode>
         <!--expirationTime>60000</expirationTime-->
         <amount>10.00</amount>
         </nod:activatePaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response




   # test execution
   Scenario: Define RPT
      Given the Execute activatePaymentNotice request scenario executed successfully
      And RPT generation

         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>#codicePA#</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:dataEsecuzionePagamento>2016-09-16</pay_i:dataEsecuzionePagamento>
         <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
         <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
         <pay_i:identificativoUnivocoVersamento>pspCarrello1_006</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
         <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
         <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
         <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
         <pay_i:datiSingoloVersamento>
         <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
         <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
         <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
         <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
         <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
         <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
         <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
         <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
         <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
         </pay_i:datiSingoloVersamento>
         </pay_i:datiVersamento>
         </pay_i:RPT>
         """

   Scenario: Execute nodoInviaRPT
      Given the Define RPT scenario executed successfully
      And initial XML nodoInviaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:intestazionePPT>
         <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
         <identificativoDominio>44444444444</identificativoDominio>
         <identificativoUnivocoVersamento>015821510121100</identificativoUnivocoVersamento>
         <codiceContestoPagamento>b0cee9a5d910445fb2f4e4b247c998e9</codiceContestoPagamento>
         </ppt:intestazionePPT>
         </soapenv:Header>
         <soapenv:Body>
         <ws:nodoInviaRPT>
         <password>pwdpwdpwd</password>
         <identificativoPSP>15376371009</identificativoPSP>
         <identificativoIntermediarioPSP>15376371009</identificativoIntermediarioPSP>
         <identificativoCanale>15376371009_01</identificativoCanale>
         <tipoFirma></tipoFirma>
         <rpt>PHBheV9pOlJQVCB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gUGFnSW5mX1JQVF9SVF82XzBfMS54c2QgIiB4bWxuczpwYXlfaT0iaHR0cDovL3d3dy5kaWdpdHBhLmdvdi5pdC9zY2hlbWFzLzIwMTEvUGFnYW1lbnRpLyIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSI+PHBheV9pOnZlcnNpb25lT2dnZXR0bz4xLjA8L3BheV9pOnZlcnNpb25lT2dnZXR0bz48cGF5X2k6ZG9taW5pbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Eb21pbmlvPjQ0NDQ0NDQ0NDQ0PC9wYXlfaTppZGVudGlmaWNhdGl2b0RvbWluaW8+PHBheV9pOmlkZW50aWZpY2F0aXZvU3RhemlvbmVSaWNoaWVkZW50ZT40NDQ0NDQ0NDQ0NF8wMTwvcGF5X2k6aWRlbnRpZmljYXRpdm9TdGF6aW9uZVJpY2hpZWRlbnRlPjwvcGF5X2k6ZG9taW5pbz48cGF5X2k6aWRlbnRpZmljYXRpdm9NZXNzYWdnaW9SaWNoaWVzdGE+TVNHUklDSElFU1RBMDE8L3BheV9pOmlkZW50aWZpY2F0aXZvTWVzc2FnZ2lvUmljaGllc3RhPjxwYXlfaTpkYXRhT3JhTWVzc2FnZ2lvUmljaGllc3RhPjIwMTYtMDktMTZUMTE6MjQ6MTA8L3BheV9pOmRhdGFPcmFNZXNzYWdnaW9SaWNoaWVzdGE+PHBheV9pOmF1dGVudGljYXppb25lU29nZ2V0dG8+Q05TPC9wYXlfaTphdXRlbnRpY2F6aW9uZVNvZ2dldHRvPjxwYXlfaTpzb2dnZXR0b1ZlcnNhbnRlPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW50ZT48cGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz5GPC9wYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPjxwYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+UkNDR0xEMDlQMDlINTAyRTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FudGU+PHBheV9pOmFuYWdyYWZpY2FWZXJzYW50ZT5HZXN1YWxkbztSaWNjaXRlbGxpPC9wYXlfaTphbmFncmFmaWNhVmVyc2FudGU+PHBheV9pOmluZGlyaXp6b1ZlcnNhbnRlPnZpYSBkZWwgZ2VzdTwvcGF5X2k6aW5kaXJpenpvVmVyc2FudGU+PHBheV9pOmNpdmljb1ZlcnNhbnRlPjExPC9wYXlfaTpjaXZpY29WZXJzYW50ZT48cGF5X2k6Y2FwVmVyc2FudGU+MDAxODY8L3BheV9pOmNhcFZlcnNhbnRlPjxwYXlfaTpsb2NhbGl0YVZlcnNhbnRlPlJvbWE8L3BheV9pOmxvY2FsaXRhVmVyc2FudGU+PHBheV9pOnByb3ZpbmNpYVZlcnNhbnRlPlJNPC9wYXlfaTpwcm92aW5jaWFWZXJzYW50ZT48cGF5X2k6bmF6aW9uZVZlcnNhbnRlPklUPC9wYXlfaTpuYXppb25lVmVyc2FudGU+PHBheV9pOmUtbWFpbFZlcnNhbnRlPmdlc3VhbGRvLnJpY2NpdGVsbGlAcG9zdGUuaXQ8L3BheV9pOmUtbWFpbFZlcnNhbnRlPjwvcGF5X2k6c29nZ2V0dG9WZXJzYW50ZT48cGF5X2k6c29nZ2V0dG9QYWdhdG9yZT48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUGFnYXRvcmU+PHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RjwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz48cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPlJDQ0dMRDA5UDA5SDUwMUU8L3BheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz48L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1BhZ2F0b3JlPjxwYXlfaTphbmFncmFmaWNhUGFnYXRvcmU+R2VzdWFsZG87UmljY2l0ZWxsaTwvcGF5X2k6YW5hZ3JhZmljYVBhZ2F0b3JlPjxwYXlfaTppbmRpcml6em9QYWdhdG9yZT52aWEgZGVsIGdlc3U8L3BheV9pOmluZGlyaXp6b1BhZ2F0b3JlPjxwYXlfaTpjaXZpY29QYWdhdG9yZT4xMTwvcGF5X2k6Y2l2aWNvUGFnYXRvcmU+PHBheV9pOmNhcFBhZ2F0b3JlPjAwMTg2PC9wYXlfaTpjYXBQYWdhdG9yZT48cGF5X2k6bG9jYWxpdGFQYWdhdG9yZT5Sb21hPC9wYXlfaTpsb2NhbGl0YVBhZ2F0b3JlPjxwYXlfaTpwcm92aW5jaWFQYWdhdG9yZT5STTwvcGF5X2k6cHJvdmluY2lhUGFnYXRvcmU+PHBheV9pOm5hemlvbmVQYWdhdG9yZT5JVDwvcGF5X2k6bmF6aW9uZVBhZ2F0b3JlPjxwYXlfaTplLW1haWxQYWdhdG9yZT5nZXN1YWxkby5yaWNjaXRlbGxpQHBvc3RlLml0PC9wYXlfaTplLW1haWxQYWdhdG9yZT48L3BheV9pOnNvZ2dldHRvUGFnYXRvcmU+PHBheV9pOmVudGVCZW5lZmljaWFyaW8+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb0JlbmVmaWNpYXJpbz48cGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz5HPC9wYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPjxwYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+MTExMTExMTExMTc8L3BheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz48L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb0JlbmVmaWNpYXJpbz48cGF5X2k6ZGVub21pbmF6aW9uZUJlbmVmaWNpYXJpbz5BWklFTkRBIFhYWDwvcGF5X2k6ZGVub21pbmF6aW9uZUJlbmVmaWNpYXJpbz48cGF5X2k6Y29kaWNlVW5pdE9wZXJCZW5lZmljaWFyaW8+MTIzPC9wYXlfaTpjb2RpY2VVbml0T3BlckJlbmVmaWNpYXJpbz48cGF5X2k6ZGVub21Vbml0T3BlckJlbmVmaWNpYXJpbz5YWFg8L3BheV9pOmRlbm9tVW5pdE9wZXJCZW5lZmljaWFyaW8+PHBheV9pOmluZGlyaXp6b0JlbmVmaWNpYXJpbz5JbmRpcml6em9CZW5lZmljaWFyaW88L3BheV9pOmluZGlyaXp6b0JlbmVmaWNpYXJpbz48cGF5X2k6Y2l2aWNvQmVuZWZpY2lhcmlvPjEyMzwvcGF5X2k6Y2l2aWNvQmVuZWZpY2lhcmlvPjxwYXlfaTpjYXBCZW5lZmljaWFyaW8+MjIyMjI8L3BheV9pOmNhcEJlbmVmaWNpYXJpbz48cGF5X2k6bG9jYWxpdGFCZW5lZmljaWFyaW8+Um9tYTwvcGF5X2k6bG9jYWxpdGFCZW5lZmljaWFyaW8+PHBheV9pOnByb3ZpbmNpYUJlbmVmaWNpYXJpbz5STTwvcGF5X2k6cHJvdmluY2lhQmVuZWZpY2lhcmlvPjxwYXlfaTpuYXppb25lQmVuZWZpY2lhcmlvPklUPC9wYXlfaTpuYXppb25lQmVuZWZpY2lhcmlvPjwvcGF5X2k6ZW50ZUJlbmVmaWNpYXJpbz48cGF5X2k6ZGF0aVZlcnNhbWVudG8+PHBheV9pOmRhdGFFc2VjdXppb25lUGFnYW1lbnRvPjIwMTYtMDktMTY8L3BheV9pOmRhdGFFc2VjdXppb25lUGFnYW1lbnRvPjxwYXlfaTppbXBvcnRvVG90YWxlRGFWZXJzYXJlPjEwLjAwPC9wYXlfaTppbXBvcnRvVG90YWxlRGFWZXJzYXJlPjxwYXlfaTp0aXBvVmVyc2FtZW50bz5QTzwvcGF5X2k6dGlwb1ZlcnNhbWVudG8+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+MDE1ODIxNTEwMTIxMTAwPC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW1lbnRvPjxwYXlfaTpjb2RpY2VDb250ZXN0b1BhZ2FtZW50bz5iMGNlZTlhNWQ5MTA0NDVmYjJmNGU0YjI0N2M5OThlOTwvcGF5X2k6Y29kaWNlQ29udGVzdG9QYWdhbWVudG8+PHBheV9pOmliYW5BZGRlYml0bz5JVDk2UjAxMjM0NTEyMzQ1MTIzNDU2Nzg5MDQ8L3BheV9pOmliYW5BZGRlYml0bz48cGF5X2k6YmljQWRkZWJpdG8+QVJUSUlUTTEwNDU8L3BheV9pOmJpY0FkZGViaXRvPjxwYXlfaTpmaXJtYVJpY2V2dXRhPjA8L3BheV9pOmZpcm1hUmljZXZ1dGE+PHBheV9pOmRhdGlTaW5nb2xvVmVyc2FtZW50bz48cGF5X2k6aW1wb3J0b1NpbmdvbG9WZXJzYW1lbnRvPjEwLjAwPC9wYXlfaTppbXBvcnRvU2luZ29sb1ZlcnNhbWVudG8+PHBheV9pOmNvbW1pc3Npb25lQ2FyaWNvUEE+MS4wMDwvcGF5X2k6Y29tbWlzc2lvbmVDYXJpY29QQT48cGF5X2k6aWJhbkFjY3JlZGl0bz5JVDk2UjAxMjM0NTQzMjEwMDAwMDAwMTIzNDU8L3BheV9pOmliYW5BY2NyZWRpdG8+PHBheV9pOmJpY0FjY3JlZGl0bz5BUlRJSVRNMTA1MDwvcGF5X2k6YmljQWNjcmVkaXRvPjxwYXlfaTppYmFuQXBwb2dnaW8+SVQ5NlIwMTIzNDU0MzIxMDAwMDAwMDEyMzQ1PC9wYXlfaTppYmFuQXBwb2dnaW8+PHBheV9pOmJpY0FwcG9nZ2lvPkFSVElJVE0xMDUwPC9wYXlfaTpiaWNBcHBvZ2dpbz48cGF5X2k6Y3JlZGVuemlhbGlQYWdhdG9yZT5DUDEuMTwvcGF5X2k6Y3JlZGVuemlhbGlQYWdhdG9yZT48cGF5X2k6Y2F1c2FsZVZlcnNhbWVudG8+cGFnYW1lbnRvIGZvdG9jw7Jww6zDqSBwcmF0aWNhIFJQVDwvcGF5X2k6Y2F1c2FsZVZlcnNhbWVudG8+PHBheV9pOmRhdGlTcGVjaWZpY2lSaXNjb3NzaW9uZT4xL2FiYzwvcGF5X2k6ZGF0aVNwZWNpZmljaVJpc2Nvc3Npb25lPjwvcGF5X2k6ZGF0aVNpbmdvbG9WZXJzYW1lbnRvPjwvcGF5X2k6ZGF0aVZlcnNhbWVudG8+PC9wYXlfaTpSUFQ+</rpt>
         </ws:nodoInviaRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoInviaRPT response
      
      #DB CHECK- POSITION_PAYMENT_STATUS
      And checks the value PAYING, PAYING_RPT, None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_orderby on db nodo_online under macro NewMod3

      #DB CHECK- POSITION_PAYMENT_STATUS_SNAPSHOT
      And checks the value PAYING_RPT, None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3

      #DB CHECK - STATI RPT
      And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO_MOD3 None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
