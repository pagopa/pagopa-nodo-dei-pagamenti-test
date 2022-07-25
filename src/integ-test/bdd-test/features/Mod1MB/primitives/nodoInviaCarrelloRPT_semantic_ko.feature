Feature: Semantic checks for nodoInviaCarrelloRPT

   Background:
      Given systems up
      And initial XML nodoInviaCarrelloRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:intestazioneCarrelloPPT>
         <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
         <identificativoCarrello>09812374659311014901220113600-83957</identificativoCarrello>
         </ppt:intestazioneCarrelloPPT>
         </soapenv:Header>
         <soapenv:Body>
         <ws:nodoInviaCarrelloRPT>
         <password>pwdpwdpwd</password>
         <identificativoPSP>AGID_01</identificativoPSP>
         <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
         <identificativoCanale>97735020584_02</identificativoCanale>
         <listaRPT>
         <elementoListaRPT>
         <identificativoDominio>44444444444</identificativoDominio>
         <identificativoUnivocoVersamento>IUV7178-2022-05-25-14:15:59.098</identificativoUnivocoVersamento>
         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
         <rpt>PHBheV9pOlJQVCB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gUGFnSW5mX1JQVF9SVF82XzBfMS54c2QgIiB4bWxuczpwYXlfaT0iaHR0cDovL3d3dy5kaWdpdHBhLmdvdi5pdC9zY2hlbWFzLzIwMTEvUGFnYW1lbnRpLyIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSI+PHBheV9pOnZlcnNpb25lT2dnZXR0bz4xLjE8L3BheV9pOnZlcnNpb25lT2dnZXR0bz48cGF5X2k6ZG9taW5pbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Eb21pbmlvPjQ0NDQ0NDQ0NDQ0PC9wYXlfaTppZGVudGlmaWNhdGl2b0RvbWluaW8+PHBheV9pOmlkZW50aWZpY2F0aXZvU3RhemlvbmVSaWNoaWVkZW50ZT40NDQ0NDQ0NDQ0NF8wMTwvcGF5X2k6aWRlbnRpZmljYXRpdm9TdGF6aW9uZVJpY2hpZWRlbnRlPjwvcGF5X2k6ZG9taW5pbz48cGF5X2k6aWRlbnRpZmljYXRpdm9NZXNzYWdnaW9SaWNoaWVzdGE+TVNHUklDSElFU1RBMDE8L3BheV9pOmlkZW50aWZpY2F0aXZvTWVzc2FnZ2lvUmljaGllc3RhPjxwYXlfaTpkYXRhT3JhTWVzc2FnZ2lvUmljaGllc3RhPjIwMjItMDUtMjVUMTQ6MTU6NTkuMDk4PC9wYXlfaTpkYXRhT3JhTWVzc2FnZ2lvUmljaGllc3RhPjxwYXlfaTphdXRlbnRpY2F6aW9uZVNvZ2dldHRvPkNOUzwvcGF5X2k6YXV0ZW50aWNhemlvbmVTb2dnZXR0bz48cGF5X2k6c29nZ2V0dG9WZXJzYW50ZT48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FudGU+PHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RjwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz48cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPlJDQ0dMRDA5UDA5SDUwMkU8L3BheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz48L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbnRlPjxwYXlfaTphbmFncmFmaWNhVmVyc2FudGU+R2VzdWFsZG87UmljY2l0ZWxsaTwvcGF5X2k6YW5hZ3JhZmljYVZlcnNhbnRlPjxwYXlfaTppbmRpcml6em9WZXJzYW50ZT52aWEgZGVsIGdlc3U8L3BheV9pOmluZGlyaXp6b1ZlcnNhbnRlPjxwYXlfaTpjaXZpY29WZXJzYW50ZT4xMTwvcGF5X2k6Y2l2aWNvVmVyc2FudGU+PHBheV9pOmNhcFZlcnNhbnRlPjAwMTg2PC9wYXlfaTpjYXBWZXJzYW50ZT48cGF5X2k6bG9jYWxpdGFWZXJzYW50ZT5Sb21hPC9wYXlfaTpsb2NhbGl0YVZlcnNhbnRlPjxwYXlfaTpwcm92aW5jaWFWZXJzYW50ZT5STTwvcGF5X2k6cHJvdmluY2lhVmVyc2FudGU+PHBheV9pOm5hemlvbmVWZXJzYW50ZT5JVDwvcGF5X2k6bmF6aW9uZVZlcnNhbnRlPjxwYXlfaTplLW1haWxWZXJzYW50ZT5nZXN1YWxkby5yaWNjaXRlbGxpQHBvc3RlLml0PC9wYXlfaTplLW1haWxWZXJzYW50ZT48L3BheV9pOnNvZ2dldHRvVmVyc2FudGU+PHBheV9pOnNvZ2dldHRvUGFnYXRvcmU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1BhZ2F0b3JlPjxwYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkY8L3BheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+PHBheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz5SQ0NHTEQwOVAwOUg1MDFFPC9wYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29QYWdhdG9yZT48cGF5X2k6YW5hZ3JhZmljYVBhZ2F0b3JlPkdlc3VhbGRvO1JpY2NpdGVsbGk8L3BheV9pOmFuYWdyYWZpY2FQYWdhdG9yZT48cGF5X2k6aW5kaXJpenpvUGFnYXRvcmU+dmlhIGRlbCBnZXN1PC9wYXlfaTppbmRpcml6em9QYWdhdG9yZT48cGF5X2k6Y2l2aWNvUGFnYXRvcmU+MTE8L3BheV9pOmNpdmljb1BhZ2F0b3JlPjxwYXlfaTpjYXBQYWdhdG9yZT4wMDE4NjwvcGF5X2k6Y2FwUGFnYXRvcmU+PHBheV9pOmxvY2FsaXRhUGFnYXRvcmU+Um9tYTwvcGF5X2k6bG9jYWxpdGFQYWdhdG9yZT48cGF5X2k6cHJvdmluY2lhUGFnYXRvcmU+Uk08L3BheV9pOnByb3ZpbmNpYVBhZ2F0b3JlPjxwYXlfaTpuYXppb25lUGFnYXRvcmU+SVQ8L3BheV9pOm5hemlvbmVQYWdhdG9yZT48cGF5X2k6ZS1tYWlsUGFnYXRvcmU+Z2VzdWFsZG8ucmljY2l0ZWxsaUBwb3N0ZS5pdDwvcGF5X2k6ZS1tYWlsUGFnYXRvcmU+PC9wYXlfaTpzb2dnZXR0b1BhZ2F0b3JlPjxwYXlfaTplbnRlQmVuZWZpY2lhcmlvPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29CZW5lZmljaWFyaW8+PHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RzwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz48cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjExMTExMTExMTE3PC9wYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29CZW5lZmljaWFyaW8+PHBheV9pOmRlbm9taW5hemlvbmVCZW5lZmljaWFyaW8+QVpJRU5EQSBYWFg8L3BheV9pOmRlbm9taW5hemlvbmVCZW5lZmljaWFyaW8+PHBheV9pOmNvZGljZVVuaXRPcGVyQmVuZWZpY2lhcmlvPjEyMzwvcGF5X2k6Y29kaWNlVW5pdE9wZXJCZW5lZmljaWFyaW8+PHBheV9pOmRlbm9tVW5pdE9wZXJCZW5lZmljaWFyaW8+WFhYPC9wYXlfaTpkZW5vbVVuaXRPcGVyQmVuZWZpY2lhcmlvPjxwYXlfaTppbmRpcml6em9CZW5lZmljaWFyaW8+SW5kaXJpenpvQmVuZWZpY2lhcmlvPC9wYXlfaTppbmRpcml6em9CZW5lZmljaWFyaW8+PHBheV9pOmNpdmljb0JlbmVmaWNpYXJpbz4xMjM8L3BheV9pOmNpdmljb0JlbmVmaWNpYXJpbz48cGF5X2k6Y2FwQmVuZWZpY2lhcmlvPjIyMjIyPC9wYXlfaTpjYXBCZW5lZmljaWFyaW8+PHBheV9pOmxvY2FsaXRhQmVuZWZpY2lhcmlvPlJvbWE8L3BheV9pOmxvY2FsaXRhQmVuZWZpY2lhcmlvPjxwYXlfaTpwcm92aW5jaWFCZW5lZmljaWFyaW8+Uk08L3BheV9pOnByb3ZpbmNpYUJlbmVmaWNpYXJpbz48cGF5X2k6bmF6aW9uZUJlbmVmaWNpYXJpbz5JVDwvcGF5X2k6bmF6aW9uZUJlbmVmaWNpYXJpbz48L3BheV9pOmVudGVCZW5lZmljaWFyaW8+PHBheV9pOmRhdGlWZXJzYW1lbnRvPjxwYXlfaTpkYXRhRXNlY3V6aW9uZVBhZ2FtZW50bz4yMDIyLTA1LTI1PC9wYXlfaTpkYXRhRXNlY3V6aW9uZVBhZ2FtZW50bz48cGF5X2k6aW1wb3J0b1RvdGFsZURhVmVyc2FyZT4xLjUwPC9wYXlfaTppbXBvcnRvVG90YWxlRGFWZXJzYXJlPjxwYXlfaTp0aXBvVmVyc2FtZW50bz5CQlQ8L3BheV9pOnRpcG9WZXJzYW1lbnRvPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW1lbnRvPklVVjcxNzgtMjAyMi0wNS0yNS0xNDoxNTo1OS4wOTg8L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+PHBheV9pOmNvZGljZUNvbnRlc3RvUGFnYW1lbnRvPkNDRDAxPC9wYXlfaTpjb2RpY2VDb250ZXN0b1BhZ2FtZW50bz48cGF5X2k6aWJhbkFkZGViaXRvPklUOTZSMDEyMzQ1NDMyMTAwMDAwMDAxMjM0NTwvcGF5X2k6aWJhbkFkZGViaXRvPjxwYXlfaTpiaWNBZGRlYml0bz5BUlRJSVRNMTA0NTwvcGF5X2k6YmljQWRkZWJpdG8+PHBheV9pOmZpcm1hUmljZXZ1dGE+MDwvcGF5X2k6ZmlybWFSaWNldnV0YT48cGF5X2k6ZGF0aVNpbmdvbG9WZXJzYW1lbnRvPjxwYXlfaTppbXBvcnRvU2luZ29sb1ZlcnNhbWVudG8+MS41MDwvcGF5X2k6aW1wb3J0b1NpbmdvbG9WZXJzYW1lbnRvPjxwYXlfaTpjb21taXNzaW9uZUNhcmljb1BBPjEuMDA8L3BheV9pOmNvbW1pc3Npb25lQ2FyaWNvUEE+PHBheV9pOmliYW5BY2NyZWRpdG8+SVQ0NVIwNzYwMTAzMjAwMDAwMDAwMDAxMDE2PC9wYXlfaTppYmFuQWNjcmVkaXRvPjxwYXlfaTpiaWNBY2NyZWRpdG8+QVJUSUlUTTEwNTA8L3BheV9pOmJpY0FjY3JlZGl0bz48cGF5X2k6aWJhbkFwcG9nZ2lvPklUNDVSMDc2MDEwMzIwMDAwMDAwMDAwMTAxNjwvcGF5X2k6aWJhbkFwcG9nZ2lvPjxwYXlfaTpiaWNBcHBvZ2dpbz5BUlRJSVRNMTA1MDwvcGF5X2k6YmljQXBwb2dnaW8+PHBheV9pOmNyZWRlbnppYWxpUGFnYXRvcmU+Q1AxLjE8L3BheV9pOmNyZWRlbnppYWxpUGFnYXRvcmU+PHBheV9pOmNhdXNhbGVWZXJzYW1lbnRvPnBhZ2FtZW50byBmb3RvY29waWUgcHJhdGljYTwvcGF5X2k6Y2F1c2FsZVZlcnNhbWVudG8+PHBheV9pOmRhdGlTcGVjaWZpY2lSaXNjb3NzaW9uZT4xL2FiYzwvcGF5X2k6ZGF0aVNwZWNpZmljaVJpc2Nvc3Npb25lPjwvcGF5X2k6ZGF0aVNpbmdvbG9WZXJzYW1lbnRvPjwvcGF5X2k6ZGF0aVZlcnNhbWVudG8+PC9wYXlfaTpSUFQ+</rpt>
         </elementoListaRPT>
         </listaRPT>
         <requireLightPayment>01</requireLightPayment>
         <multiBeneficiario>1</multiBeneficiario>
         </ws:nodoInviaCarrelloRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   # idCarrello value check: idCarrello not in db [SEM_Mb_01]
   Scenario Outline: Check PPT_MULTIBENEFICIARIO error on non-existent psp
      Given <tag> with <value> in nodoInviaCarrelloRPT
      When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTI_BENEFICIARIO of nodoInviaCarrelloRPT response
      Examples:
         | tag                    | value                               | soapUI test |
         | identificativoCarrello | 444444444431101985140613690012216   | SEM_MB_01   |
         | identificativoCarrello | 90000000001311019851406136900-51484 | SEM_MB_01   |
         | identificativoCarrello | 44444444444311019851406136900-21630 | SEM_MB_01   |
         | identificativoCarrello | 7777777777311019851406136900-65584  | SEM_MB_01   |

   Scenario Outline: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent domain
      Given <tag> with <value> in nodoInviaCarrelloRPT
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoInviaCarrelloRPT response
      Examples:
         | tag                    | value                               | soapUI test |
         | identificativoCarrello | 31101985140613690044444444444-67668 | SEM_MB_01   |
         | identificativoDominio  | idDominioUnknown                    | SEM_MB_02   |

   # station value check: combination idDominio-noticeNumber identifies a station not present inside column ID_CARRELLO in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_Mb_11]
   Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
      Given identificativoDominio with 77777777777 in nodoInviaCarrelloRPT
      And noticeNumber with <value> in nodoInviaCarrelloRPT
      When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoInviaCarrelloRPT response
      Examples:
         | value              | soapUI test                                            |
         | 5                  | SEM_AIPR_12 - auxDigit inesistente                     |
         | 011456789012345678 | SEM_AIPR_12 - auxDigit 0 - progressivo inesistente     |
         | 316456789012345678 | SEM_AIPR_12 - auxDigit 3 - segregationCode inesistente |


   # station value check: combination idDominio-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field ENABLED = N in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_Mb_12]
   Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
      Given identificativoDominio with 77777777777 in nodoInviaCarrelloRPT
      And noticeNumber with 088456789012345678 in nodoInviaCarrelloRPT
      When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of nodoInviaCarrelloRPT response


   # pa broker value check: combination idDominio-noticeNumber identifies a pa broker corresponding to an ID_INTERMEDIARIO_PA value with field ENABLED = N in NODO4_CFG.INTERMEDIARI_PA table of nodo-dei-pagamenti database [SEM_Mb_13]
   Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
      Given identificativoDominio with 77777777777 in nodoInviaCarrelloRPT
      And noticeNumber with 088456789012345678 in nodoInviaCarrelloRPT
      When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of nodoInviaCarrelloRPT response