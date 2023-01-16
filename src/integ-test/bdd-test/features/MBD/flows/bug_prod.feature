Feature: bug_prod

    Background:
        Given systems up

    # Scenario: nodoInviaRPT
    #     Given initial XML nodoInviaRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazionePPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoDominio>80184430587</identificativoDominio>
    #         <identificativoUnivocoVersamento>70E000GLMI5JHJ1HH178B5PXOJNMRX4DPL7</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>n/a</codiceContestoPagamento>
    #         </ppt:intestazionePPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaRPT>
    #         <password>#password#</password>
    #         <identificativoPSP>#psp_AGID#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale_AGID_02#</identificativoCanale>
    #         <tipoFirma></tipoFirma>
    #         <rpt>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pgo8cGF5X2o6UlBUIHhtbG5zOnBheV9qPSJodHRwOi8vd3d3LmRpZ2l0cGEuZ292Lml0L3NjaGVtYXMvMjAxMS9QYWdhbWVudGkvIiB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gaHR0cDovL3d3dy5kaWdpdHBhLmdvdi5pdC9zY2hlbWFzLzIwMTEvUGFnYW1lbnRpL1BhZ0luZl9SUFRfUlRfNl8yXzAueHNkIj4KICAgIDxwYXlfajp2ZXJzaW9uZU9nZ2V0dG8+Ni4yLjA8L3BheV9qOnZlcnNpb25lT2dnZXR0bz4KICAgIDxwYXlfajpkb21pbmlvPgogICAgICAgIDxwYXlfajppZGVudGlmaWNhdGl2b0RvbWluaW8+ODAxODQ0MzA1ODc8L3BheV9qOmlkZW50aWZpY2F0aXZvRG9taW5pbz4KICAgICAgICA8cGF5X2o6aWRlbnRpZmljYXRpdm9TdGF6aW9uZVJpY2hpZWRlbnRlPjgwMTg0NDMwNTg3XzAxPC9wYXlfajppZGVudGlmaWNhdGl2b1N0YXppb25lUmljaGllZGVudGU+CiAgICA8L3BheV9qOmRvbWluaW8+CiAgICA8cGF5X2o6aWRlbnRpZmljYXRpdm9NZXNzYWdnaW9SaWNoaWVzdGE+MDE5MGJhMjllNzhiNGUxOTlhMTY3MjIxMzYwZGM0ZDc8L3BheV9qOmlkZW50aWZpY2F0aXZvTWVzc2FnZ2lvUmljaGllc3RhPgogICAgPHBheV9qOmRhdGFPcmFNZXNzYWdnaW9SaWNoaWVzdGE+MjAyMy0wMS0wMlQwODo1MTo0MjwvcGF5X2o6ZGF0YU9yYU1lc3NhZ2dpb1JpY2hpZXN0YT4KICAgIDxwYXlfajphdXRlbnRpY2F6aW9uZVNvZ2dldHRvPkNOUzwvcGF5X2o6YXV0ZW50aWNhemlvbmVTb2dnZXR0bz4KICAgIDxwYXlfajpzb2dnZXR0b1BhZ2F0b3JlPgogICAgICAgIDxwYXlfajppZGVudGlmaWNhdGl2b1VuaXZvY29QYWdhdG9yZT4KICAgICAgICAgICAgPHBheV9qOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RjwvcGF5X2o6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz4KICAgICAgICAgICAgPHBheV9qOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz5CTlZNU004NUExOUk0NDFYPC9wYXlfajpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+CiAgICAgICAgPC9wYXlfajppZGVudGlmaWNhdGl2b1VuaXZvY29QYWdhdG9yZT4KICAgICAgICA8cGF5X2o6YW5hZ3JhZmljYVBhZ2F0b3JlPk1hc3NpbW8gQmVudmVnbsODwrk8L3BheV9qOmFuYWdyYWZpY2FQYWdhdG9yZT4KICAgIDwvcGF5X2o6c29nZ2V0dG9QYWdhdG9yZT4KICAgIDxwYXlfajplbnRlQmVuZWZpY2lhcmlvPgogICAgICAgIDxwYXlfajppZGVudGlmaWNhdGl2b1VuaXZvY29CZW5lZmljaWFyaW8+CiAgICAgICAgICAgIDxwYXlfajp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9qOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+CiAgICAgICAgICAgIDxwYXlfajpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+ODAxODQ0MzA1ODc8L3BheV9qOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz4KICAgICAgICA8L3BheV9qOmlkZW50aWZpY2F0aXZvVW5pdm9jb0JlbmVmaWNpYXJpbz4KICAgICAgICA8cGF5X2o6ZGVub21pbmF6aW9uZUJlbmVmaWNpYXJpbz5NaW5pc3Rlcm8gZGVsbGEgR2l1c3RpemlhPC9wYXlfajpkZW5vbWluYXppb25lQmVuZWZpY2lhcmlvPgogICAgICAgIDxwYXlfajpjb2RpY2VVbml0T3BlckJlbmVmaWNpYXJpbz4wMTIwMjYwMDk3PC9wYXlfajpjb2RpY2VVbml0T3BlckJlbmVmaWNpYXJpbz4KICAgICAgICA8cGF5X2o6ZGVub21Vbml0T3BlckJlbmVmaWNpYXJpbz5UcmlidW5hbGUgT3JkaW5hcmlvIC0gQnVzdG8gQXJzaXppbzwvcGF5X2o6ZGVub21Vbml0T3BlckJlbmVmaWNpYXJpbz4KICAgIDwvcGF5X2o6ZW50ZUJlbmVmaWNpYXJpbz4KICAgIDxwYXlfajpkYXRpVmVyc2FtZW50bz4KICAgICAgICA8cGF5X2o6ZGF0YUVzZWN1emlvbmVQYWdhbWVudG8+MjAyMy0wMS0wMjwvcGF5X2o6ZGF0YUVzZWN1emlvbmVQYWdhbWVudG8+CiAgICAgICAgPHBheV9qOmltcG9ydG9Ub3RhbGVEYVZlcnNhcmU+NDMuMDA8L3BheV9qOmltcG9ydG9Ub3RhbGVEYVZlcnNhcmU+CiAgICAgICAgPHBheV9qOnRpcG9WZXJzYW1lbnRvPkJCVDwvcGF5X2o6dGlwb1ZlcnNhbWVudG8+CiAgICAgICAgPHBheV9qOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+NzBFMDAwR0xNSTVKSEoxSEgxNzhCNVBYT0pOTVJYNERQTDc8L3BheV9qOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+CiAgICAgICAgPHBheV9qOmNvZGljZUNvbnRlc3RvUGFnYW1lbnRvPm4vYTwvcGF5X2o6Y29kaWNlQ29udGVzdG9QYWdhbWVudG8+CiAgICAgICAgPHBheV9qOmZpcm1hUmljZXZ1dGE+MDwvcGF5X2o6ZmlybWFSaWNldnV0YT4KICAgICAgICA8cGF5X2o6ZGF0aVNpbmdvbG9WZXJzYW1lbnRvPgogICAgICAgICAgICA8cGF5X2o6aW1wb3J0b1NpbmdvbG9WZXJzYW1lbnRvPjQzLjAwPC9wYXlfajppbXBvcnRvU2luZ29sb1ZlcnNhbWVudG8+CiAgICAgICAgICAgIDxwYXlfajppYmFuQWNjcmVkaXRvPklUMDRPMDEwMDAwMzI0NTM1MDAwODMzMjEwMDwvcGF5X2o6aWJhbkFjY3JlZGl0bz4KICAgICAgICAgICAgPHBheV9qOmliYW5BcHBvZ2dpbz5JVDk0WjA3NjAxMDMyMDAwMDAwNTcxNTIwNDM8L3BheV9qOmliYW5BcHBvZ2dpbz4KICAgICAgICAgICAgPHBheV9qOmNhdXNhbGVWZXJzYW1lbnRvPi9SRkIvNzBFMDAwR0xNSTVKSEoxSEgxNzhCNVBYT0pOTVJYNERQTDcvNDMuMDAvVFhUL1JpY29yc28gZGl2b3J6aW8gY29uZ2l1bnRvIENvbmZvcnRpbm8gRWxlbmEgKENORkxORTg0QzcxSTQ0MVMpIC8gUmFjbyBHaW9yZ2lvIChSQ0FHUkc4MkgwPC9wYXlfajpjYXVzYWxlVmVyc2FtZW50bz4KICAgICAgICAgICAgPHBheV9qOmRhdGlTcGVjaWZpY2lSaXNjb3NzaW9uZT45LzA3MDIxMDBUUy9DT05UUklCPC9wYXlfajpkYXRpU3BlY2lmaWNpUmlzY29zc2lvbmU+CiAgICAgICAgPC9wYXlfajpkYXRpU2luZ29sb1ZlcnNhbWVudG8+CiAgICA8L3BheV9qOmRhdGlWZXJzYW1lbnRvPgo8L3BheV9qOlJQVD4K</rpt>
    #         </ws:nodoInviaRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    #     Then check esito is KO of nodoInviaRPT response

    Scenario: nodoInviaCarrelloRPT
        Given initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>n/a</identificativoCarrello>
            </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaCarrelloRPT>
            <password>#password#</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_02#</identificativoCanale>
            <listaRPT>
            <!--1 or more repetitions:-->
            <elementoListaRPT>
            <identificativoDominio>80184430587</identificativoDominio>
            <identificativoUnivocoVersamento>70E000GLMI5JHJ1HH178B5PXOJNMRX4DPL7</identificativoUnivocoVersamento>
            <codiceContestoPagamento>n/a</codiceContestoPagamento>
            <rpt>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pgo8cGF5X2o6UlBUIHhtbG5zOnBheV9qPSJodHRwOi8vd3d3LmRpZ2l0cGEuZ292Lml0L3NjaGVtYXMvMjAxMS9QYWdhbWVudGkvIiB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gaHR0cDovL3d3dy5kaWdpdHBhLmdvdi5pdC9zY2hlbWFzLzIwMTEvUGFnYW1lbnRpL1BhZ0luZl9SUFRfUlRfNl8yXzAueHNkIj4KICAgIDxwYXlfajp2ZXJzaW9uZU9nZ2V0dG8+Ni4yLjA8L3BheV9qOnZlcnNpb25lT2dnZXR0bz4KICAgIDxwYXlfajpkb21pbmlvPgogICAgICAgIDxwYXlfajppZGVudGlmaWNhdGl2b0RvbWluaW8+ODAxODQ0MzA1ODc8L3BheV9qOmlkZW50aWZpY2F0aXZvRG9taW5pbz4KICAgICAgICA8cGF5X2o6aWRlbnRpZmljYXRpdm9TdGF6aW9uZVJpY2hpZWRlbnRlPjgwMTg0NDMwNTg3XzAxPC9wYXlfajppZGVudGlmaWNhdGl2b1N0YXppb25lUmljaGllZGVudGU+CiAgICA8L3BheV9qOmRvbWluaW8+CiAgICA8cGF5X2o6aWRlbnRpZmljYXRpdm9NZXNzYWdnaW9SaWNoaWVzdGE+MDE5MGJhMjllNzhiNGUxOTlhMTY3MjIxMzYwZGM0ZDc8L3BheV9qOmlkZW50aWZpY2F0aXZvTWVzc2FnZ2lvUmljaGllc3RhPgogICAgPHBheV9qOmRhdGFPcmFNZXNzYWdnaW9SaWNoaWVzdGE+MjAyMy0wMS0wMlQwODo1MTo0MjwvcGF5X2o6ZGF0YU9yYU1lc3NhZ2dpb1JpY2hpZXN0YT4KICAgIDxwYXlfajphdXRlbnRpY2F6aW9uZVNvZ2dldHRvPkNOUzwvcGF5X2o6YXV0ZW50aWNhemlvbmVTb2dnZXR0bz4KICAgIDxwYXlfajpzb2dnZXR0b1BhZ2F0b3JlPgogICAgICAgIDxwYXlfajppZGVudGlmaWNhdGl2b1VuaXZvY29QYWdhdG9yZT4KICAgICAgICAgICAgPHBheV9qOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RjwvcGF5X2o6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz4KICAgICAgICAgICAgPHBheV9qOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz5CTlZNU004NUExOUk0NDFYPC9wYXlfajpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+CiAgICAgICAgPC9wYXlfajppZGVudGlmaWNhdGl2b1VuaXZvY29QYWdhdG9yZT4KICAgICAgICA8cGF5X2o6YW5hZ3JhZmljYVBhZ2F0b3JlPk1hc3NpbW8gQmVudmVnbsODwrk8L3BheV9qOmFuYWdyYWZpY2FQYWdhdG9yZT4KICAgIDwvcGF5X2o6c29nZ2V0dG9QYWdhdG9yZT4KICAgIDxwYXlfajplbnRlQmVuZWZpY2lhcmlvPgogICAgICAgIDxwYXlfajppZGVudGlmaWNhdGl2b1VuaXZvY29CZW5lZmljaWFyaW8+CiAgICAgICAgICAgIDxwYXlfajp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9qOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+CiAgICAgICAgICAgIDxwYXlfajpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+ODAxODQ0MzA1ODc8L3BheV9qOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz4KICAgICAgICA8L3BheV9qOmlkZW50aWZpY2F0aXZvVW5pdm9jb0JlbmVmaWNpYXJpbz4KICAgICAgICA8cGF5X2o6ZGVub21pbmF6aW9uZUJlbmVmaWNpYXJpbz5NaW5pc3Rlcm8gZGVsbGEgR2l1c3RpemlhPC9wYXlfajpkZW5vbWluYXppb25lQmVuZWZpY2lhcmlvPgogICAgICAgIDxwYXlfajpjb2RpY2VVbml0T3BlckJlbmVmaWNpYXJpbz4wMTIwMjYwMDk3PC9wYXlfajpjb2RpY2VVbml0T3BlckJlbmVmaWNpYXJpbz4KICAgICAgICA8cGF5X2o6ZGVub21Vbml0T3BlckJlbmVmaWNpYXJpbz5UcmlidW5hbGUgT3JkaW5hcmlvIC0gQnVzdG8gQXJzaXppbzwvcGF5X2o6ZGVub21Vbml0T3BlckJlbmVmaWNpYXJpbz4KICAgIDwvcGF5X2o6ZW50ZUJlbmVmaWNpYXJpbz4KICAgIDxwYXlfajpkYXRpVmVyc2FtZW50bz4KICAgICAgICA8cGF5X2o6ZGF0YUVzZWN1emlvbmVQYWdhbWVudG8+MjAyMy0wMS0wMjwvcGF5X2o6ZGF0YUVzZWN1emlvbmVQYWdhbWVudG8+CiAgICAgICAgPHBheV9qOmltcG9ydG9Ub3RhbGVEYVZlcnNhcmU+NDMuMDA8L3BheV9qOmltcG9ydG9Ub3RhbGVEYVZlcnNhcmU+CiAgICAgICAgPHBheV9qOnRpcG9WZXJzYW1lbnRvPkJCVDwvcGF5X2o6dGlwb1ZlcnNhbWVudG8+CiAgICAgICAgPHBheV9qOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+NzBFMDAwR0xNSTVKSEoxSEgxNzhCNVBYT0pOTVJYNERQTDc8L3BheV9qOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+CiAgICAgICAgPHBheV9qOmNvZGljZUNvbnRlc3RvUGFnYW1lbnRvPm4vYTwvcGF5X2o6Y29kaWNlQ29udGVzdG9QYWdhbWVudG8+CiAgICAgICAgPHBheV9qOmZpcm1hUmljZXZ1dGE+MDwvcGF5X2o6ZmlybWFSaWNldnV0YT4KICAgICAgICA8cGF5X2o6ZGF0aVNpbmdvbG9WZXJzYW1lbnRvPgogICAgICAgICAgICA8cGF5X2o6aW1wb3J0b1NpbmdvbG9WZXJzYW1lbnRvPjQzLjAwPC9wYXlfajppbXBvcnRvU2luZ29sb1ZlcnNhbWVudG8+CiAgICAgICAgICAgIDxwYXlfajppYmFuQWNjcmVkaXRvPklUMDRPMDEwMDAwMzI0NTM1MDAwODMzMjEwMDwvcGF5X2o6aWJhbkFjY3JlZGl0bz4KICAgICAgICAgICAgPHBheV9qOmliYW5BcHBvZ2dpbz5JVDk0WjA3NjAxMDMyMDAwMDAwNTcxNTIwNDM8L3BheV9qOmliYW5BcHBvZ2dpbz4KICAgICAgICAgICAgPHBheV9qOmNhdXNhbGVWZXJzYW1lbnRvPi9SRkIvNzBFMDAwR0xNSTVKSEoxSEgxNzhCNVBYT0pOTVJYNERQTDcvNDMuMDAvVFhUL1JpY29yc28gZGl2b3J6aW8gY29uZ2l1bnRvIENvbmZvcnRpbm8gRWxlbmEgKENORkxORTg0QzcxSTQ0MVMpIC8gUmFjbyBHaW9yZ2lvIChSQ0FHUkc4MkgwPC9wYXlfajpjYXVzYWxlVmVyc2FtZW50bz4KICAgICAgICAgICAgPHBheV9qOmRhdGlTcGVjaWZpY2lSaXNjb3NzaW9uZT45LzA3MDIxMDBUUy9DT05UUklCPC9wYXlfajpkYXRpU3BlY2lmaWNpUmlzY29zc2lvbmU+CiAgICAgICAgPC9wYXlfajpkYXRpU2luZ29sb1ZlcnNhbWVudG8+CiAgICA8L3BheV9qOmRhdGlWZXJzYW1lbnRvPgo8L3BheV9qOlJQVD4K</rpt>
            </elementoListaRPT>
            </listaRPT>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response