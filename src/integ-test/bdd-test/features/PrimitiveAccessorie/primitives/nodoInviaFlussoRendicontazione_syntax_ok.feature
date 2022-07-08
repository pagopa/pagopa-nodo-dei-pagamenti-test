Feature: Syntax checks for nodoInviaFlussoRendicontazione - OK

    Background:
        Given systems up

    # [SIN_NIFR_02]
    Scenario: Check valid response for nodoInviaFlussoRendicontazione primitive
        Given initial XML nodoInviaFlussoRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoInviaFlussoRendicontazione>
            <identificativoPSP>50000000001</identificativoPSP>
            <identificativoIntermediarioPSP>50000000001</identificativoIntermediarioPSP>
            <identificativoCanale>50000000001_03</identificativoCanale>
            <password>pwdpwdpwd</password>
            <identificativoDominio>55555555555</identificativoDominio>
            <identificativoFlusso>2022-07-0850000000001-8472</identificativoFlusso>
            <dataOraFlusso>2022-07-08T12:13:06.032</dataOraFlusso>
            <xmlRendicontazione>PHBheV9pOkZsdXNzb1JpdmVyc2FtZW50byB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gRmx1c3NvUmVuZGljb250YXppb25lX3ZfMV8wXzEueHNkICIgeG1sbnM6cGF5X2k9Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiPjxwYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+MS4wPC9wYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+PHBheV9pOmlkZW50aWZpY2F0aXZvRmx1c3NvPjIwMjItMDctMDg1MDAwMDAwMDAwMS04NDcyPC9wYXlfaTppZGVudGlmaWNhdGl2b0ZsdXNzbz48cGF5X2k6ZGF0YU9yYUZsdXNzbz4yMDIyLTA3LTA4VDEyOjEzOjA2LjAzMjwvcGF5X2k6ZGF0YU9yYUZsdXNzbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+SVVWODY4Mi0yMDIyLTA3LTA4LTEyOjEzOjA2LjAzMjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+PHBheV9pOmRhdGFSZWdvbGFtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhUmVnb2xhbWVudG8+PHBheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb01pdHRlbnRlPjxwYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+PHBheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz41MDAwMDAwMDAwMTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvTWl0dGVudGU+PHBheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT5kZW5NaXR0XzE8L3BheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT48L3BheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+QklDSURQU1A8L3BheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+PHBheV9pOmlzdGl0dXRvUmljZXZlbnRlPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RzwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz48cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPmNvZElkVW5pdl8yPC9wYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PHBheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGU+ZGVuUmljXzI8L3BheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGU+PC9wYXlfaTppc3RpdHV0b1JpY2V2ZW50ZT48cGF5X2k6bnVtZXJvVG90YWxlUGFnYW1lbnRpPjE8L3BheV9pOm51bWVyb1RvdGFsZVBhZ2FtZW50aT48cGF5X2k6aW1wb3J0b1RvdGFsZVBhZ2FtZW50aT4yMC4wMDwvcGF5X2k6aW1wb3J0b1RvdGFsZVBhZ2FtZW50aT48cGF5X2k6ZGF0aVNpbmdvbGlQYWdhbWVudGk+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+SVVWODY4Mi0yMDIyLTA3LTA4LTEyOjEzOjA2LjAzMjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FtZW50bz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmlzY29zc2lvbmU+SVVWODY4Mi0yMDIyLTA3LTA4LTEyOjEzOjA2LjAzMjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmlzY29zc2lvbmU+PHBheV9pOmluZGljZURhdGlTaW5nb2xvUGFnYW1lbnRvPjE8L3BheV9pOmluZGljZURhdGlTaW5nb2xvUGFnYW1lbnRvPjxwYXlfaTpzaW5nb2xvSW1wb3J0b1BhZ2F0bz4xMC4wMDwvcGF5X2k6c2luZ29sb0ltcG9ydG9QYWdhdG8+PHBheV9pOmNvZGljZUVzaXRvU2luZ29sb1BhZ2FtZW50bz4wPC9wYXlfaTpjb2RpY2VFc2l0b1NpbmdvbG9QYWdhbWVudG8+PHBheV9pOmRhdGFFc2l0b1NpbmdvbG9QYWdhbWVudG8+MjAyMi0wNy0wODwvcGF5X2k6ZGF0YUVzaXRvU2luZ29sb1BhZ2FtZW50bz48L3BheV9pOmRhdGlTaW5nb2xpUGFnYW1lbnRpPjwvcGF5X2k6Rmx1c3NvUml2ZXJzYW1lbnRvPg==</xmlRendicontazione>
            </ws:nodoInviaFlussoRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaFlussoRendicontazione response

    # [SIN_NIFR_06]
    Scenario: Check valid response for nodoInviaFlussoRendicontazione primitive
        Given initial XML nodoInviaFlussoRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoInviaFlussoRendicontazione>
            <identificativoPSP>50000000001</identificativoPSP>
            <identificativoIntermediarioPSP>50000000001</identificativoIntermediarioPSP>
            <identificativoCanale>50000000001_03</identificativoCanale>
            <password>pwdpwdpwd</password>
            <identificativoDominio>55555555555</identificativoDominio>
            <identificativoFlusso>2022-07-0850000000001-6888</identificativoFlusso>
            <dataOraFlusso>2022-07-08T12:37:52.462</dataOraFlusso>
            <xmlRendicontazione>PHBheV9pOkZsdXNzb1JpdmVyc2FtZW50byB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gRmx1c3NvUmVuZGljb250YXppb25lX3ZfMV8wXzEueHNkICIgeG1sbnM6cGF5X2k9Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiPjxwYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+MS4wPC9wYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+PHBheV9pOmlkZW50aWZpY2F0aXZvRmx1c3NvPjIwMjItMDctMDg1MDAwMDAwMDAwMS02ODg4PC9wYXlfaTppZGVudGlmaWNhdGl2b0ZsdXNzbz48cGF5X2k6ZGF0YU9yYUZsdXNzbz4yMDIyLTA3LTA4VDEyOjM3OjUyLjQ2MjwvcGF5X2k6ZGF0YU9yYUZsdXNzbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+SVVWNDAzMi0yMDIyLTA3LTA4LTEyOjM3OjUyLjQ2MjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+PHBheV9pOmRhdGFSZWdvbGFtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhUmVnb2xhbWVudG8+PHBheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb01pdHRlbnRlPjxwYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+PHBheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz41MDAwMDAwMDAwMTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvTWl0dGVudGU+PHBheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT5kZW5NaXR0XzE8L3BheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT48L3BheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+QklDSURQU1A8L3BheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+PHBheV9pOmlzdGl0dXRvUmljZXZlbnRlPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RzwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz48cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPmNvZElkVW5pdl8yPC9wYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PHBheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGU+ZGVuUmljXzI8L3BheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGU+PC9wYXlfaTppc3RpdHV0b1JpY2V2ZW50ZT48cGF5X2k6bnVtZXJvVG90YWxlUGFnYW1lbnRpPjE8L3BheV9pOm51bWVyb1RvdGFsZVBhZ2FtZW50aT48cGF5X2k6aW1wb3J0b1RvdGFsZVBhZ2FtZW50aT4yMC4wMDwvcGF5X2k6aW1wb3J0b1RvdGFsZVBhZ2FtZW50aT48cGF5X2k6ZGF0aVNpbmdvbGlQYWdhbWVudGk+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+SVVWNDAzMi0yMDIyLTA3LTA4LTEyOjM3OjUyLjQ2MjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FtZW50bz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmlzY29zc2lvbmU+SVVWNDAzMi0yMDIyLTA3LTA4LTEyOjM3OjUyLjQ2MjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmlzY29zc2lvbmU+PHBheV9pOmluZGljZURhdGlTaW5nb2xvUGFnYW1lbnRvPjE8L3BheV9pOmluZGljZURhdGlTaW5nb2xvUGFnYW1lbnRvPjxwYXlfaTpzaW5nb2xvSW1wb3J0b1BhZ2F0bz4xMC4wMDwvcGF5X2k6c2luZ29sb0ltcG9ydG9QYWdhdG8+PHBheV9pOmNvZGljZUVzaXRvU2luZ29sb1BhZ2FtZW50bz4wPC9wYXlfaTpjb2RpY2VFc2l0b1NpbmdvbG9QYWdhbWVudG8+PHBheV9pOmRhdGFFc2l0b1NpbmdvbG9QYWdhbWVudG8+MjAyMi0wNy0wODwvcGF5X2k6ZGF0YUVzaXRvU2luZ29sb1BhZ2FtZW50bz48L3BheV9pOmRhdGlTaW5nb2xpUGFnYW1lbnRpPjwvcGF5X2k6Rmx1c3NvUml2ZXJzYW1lbnRvPg==</xmlRendicontazione>
            </ws:nodoInviaFlussoRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaFlussoRendicontazione response

    Scenario Outline: Check valid response for nodoInviaFlussoRendicontazione primitive
        Given initial XML nodoInviaFlussoRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoInviaFlussoRendicontazione>
            <identificativoPSP>50000000001</identificativoPSP>
            <identificativoIntermediarioPSP>50000000001</identificativoIntermediarioPSP>
            <identificativoCanale>50000000001_03</identificativoCanale>
            <password>pwdpwdpwd</password>
            <identificativoDominio>55555555555</identificativoDominio>
            <identificativoFlusso>2022-07-0850000000001-8472</identificativoFlusso>
            <dataOraFlusso>2022-07-08T12:13:06.032</dataOraFlusso>
            <xmlRendicontazione>#xmlRendicontazione#</xmlRendicontazione>
            </ws:nodoInviaFlussoRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <tag> with <tag_value> in nodoInviaFlussoRendicontazione
        When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaFlussoRendicontazione response
        Examples:
            | tag                                   | tag_value                            | soapUI test |
            | xmlRendicontazione                    | PHBheV9pOkZsdXNzb1JpdmVyc2FtZW50byB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gRmx1c3NvUmVuZGljb250YXppb25lX3ZfMV8wXzEueHNkICIgeG1sbnM6cGF5X2k9Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiPjxwYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+MS4wPC9wYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+PHBheV9pOmlkZW50aWZpY2F0aXZvRmx1c3NvPjIwMjItMDctMDg1MDAwMDAwMDAwMS0yMTU5PC9wYXlfaTppZGVudGlmaWNhdGl2b0ZsdXNzbz48cGF5X2k6ZGF0YU9yYUZsdXNzbz4yMDIyLTA3LTA4VDE0OjQ5OjI4LjI3MTwvcGF5X2k6ZGF0YU9yYUZsdXNzbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+SVVWNTA4Ni0yMDIyLTA3LTA4LTE0OjQ5OjI4LjI3MTwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+PHBheV9pOmRhdGFSZWdvbGFtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhUmVnb2xhbWVudG8+PHBheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb01pdHRlbnRlPjxwYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+PHBheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz41MDAwMDAwMDAwMTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvTWl0dGVudGU+PCEtLXBheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT5kZW5NaXR0XzE8L3BheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZS0tPjwvcGF5X2k6aXN0aXR1dG9NaXR0ZW50ZT48cGF5X2k6Y29kaWNlQmljQmFuY2FEaVJpdmVyc2FtZW50bz5CSUNJRFBTUDwvcGF5X2k6Y29kaWNlQmljQmFuY2FEaVJpdmVyc2FtZW50bz48cGF5X2k6aXN0aXR1dG9SaWNldmVudGU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1JpY2V2ZW50ZT48cGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz5HPC9wYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPjxwYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+Y29kSWRVbml2XzI8L3BheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz48L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1JpY2V2ZW50ZT48cGF5X2k6ZGVub21pbmF6aW9uZVJpY2V2ZW50ZT5kZW5SaWNfMjwvcGF5X2k6ZGVub21pbmF6aW9uZVJpY2V2ZW50ZT48L3BheV9pOmlzdGl0dXRvUmljZXZlbnRlPjxwYXlfaTpudW1lcm9Ub3RhbGVQYWdhbWVudGk+MTwvcGF5X2k6bnVtZXJvVG90YWxlUGFnYW1lbnRpPjxwYXlfaTppbXBvcnRvVG90YWxlUGFnYW1lbnRpPjIwLjAwPC9wYXlfaTppbXBvcnRvVG90YWxlUGFnYW1lbnRpPjxwYXlfaTpkYXRpU2luZ29saVBhZ2FtZW50aT48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FtZW50bz5JVVY1MDg2LTIwMjItMDctMDgtMTQ6NDk6MjguMjcxPC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW1lbnRvPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaXNjb3NzaW9uZT5JVVY1MDg2LTIwMjItMDctMDgtMTQ6NDk6MjguMjcxPC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaXNjb3NzaW9uZT48cGF5X2k6aW5kaWNlRGF0aVNpbmdvbG9QYWdhbWVudG8+MTwvcGF5X2k6aW5kaWNlRGF0aVNpbmdvbG9QYWdhbWVudG8+PHBheV9pOnNpbmdvbG9JbXBvcnRvUGFnYXRvPjEwLjAwPC9wYXlfaTpzaW5nb2xvSW1wb3J0b1BhZ2F0bz48cGF5X2k6Y29kaWNlRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjA8L3BheV9pOmNvZGljZUVzaXRvU2luZ29sb1BhZ2FtZW50bz48cGF5X2k6ZGF0YUVzaXRvU2luZ29sb1BhZ2FtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjwvcGF5X2k6ZGF0aVNpbmdvbGlQYWdhbWVudGk+PC9wYXlfaTpGbHVzc29SaXZlcnNhbWVudG8+                             | SIN_NIFR_60 |
            | xmlRendicontazione                    | PHBheV9pOkZsdXNzb1JpdmVyc2FtZW50byB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gRmx1c3NvUmVuZGljb250YXppb25lX3ZfMV8wXzEueHNkICIgeG1sbnM6cGF5X2k9Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiPjxwYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+MS4wPC9wYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+PHBheV9pOmlkZW50aWZpY2F0aXZvRmx1c3NvPjIwMjItMDctMDg1MDAwMDAwMDAwMS05MTIxPC9wYXlfaTppZGVudGlmaWNhdGl2b0ZsdXNzbz48cGF5X2k6ZGF0YU9yYUZsdXNzbz4yMDIyLTA3LTA4VDE0OjQzOjA4LjAxMTwvcGF5X2k6ZGF0YU9yYUZsdXNzbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+SVVWODA0NS0yMDIyLTA3LTA4LTE0OjQzOjA4LjAxMTwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+PHBheV9pOmRhdGFSZWdvbGFtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhUmVnb2xhbWVudG8+PHBheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb01pdHRlbnRlPjxwYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+PHBheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz41MDAwMDAwMDAwMTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvTWl0dGVudGU+PHBheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT5kZW5NaXR0XzE8L3BheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT48L3BheV9pOmlzdGl0dXRvTWl0dGVudGU+PCEtLXBheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+QklDSURQU1A8L3BheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8tLT48cGF5X2k6aXN0aXR1dG9SaWNldmVudGU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1JpY2V2ZW50ZT48cGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz5HPC9wYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPjxwYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+Y29kSWRVbml2XzI8L3BheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz48L3BheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1JpY2V2ZW50ZT48cGF5X2k6ZGVub21pbmF6aW9uZVJpY2V2ZW50ZT5kZW5SaWNfMjwvcGF5X2k6ZGVub21pbmF6aW9uZVJpY2V2ZW50ZT48L3BheV9pOmlzdGl0dXRvUmljZXZlbnRlPjxwYXlfaTpudW1lcm9Ub3RhbGVQYWdhbWVudGk+MTwvcGF5X2k6bnVtZXJvVG90YWxlUGFnYW1lbnRpPjxwYXlfaTppbXBvcnRvVG90YWxlUGFnYW1lbnRpPjIwLjAwPC9wYXlfaTppbXBvcnRvVG90YWxlUGFnYW1lbnRpPjxwYXlfaTpkYXRpU2luZ29saVBhZ2FtZW50aT48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FtZW50bz5JVVY4MDQ1LTIwMjItMDctMDgtMTQ6NDM6MDguMDExPC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW1lbnRvPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaXNjb3NzaW9uZT5JVVY4MDQ1LTIwMjItMDctMDgtMTQ6NDM6MDguMDExPC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaXNjb3NzaW9uZT48cGF5X2k6aW5kaWNlRGF0aVNpbmdvbG9QYWdhbWVudG8+MTwvcGF5X2k6aW5kaWNlRGF0aVNpbmdvbG9QYWdhbWVudG8+PHBheV9pOnNpbmdvbG9JbXBvcnRvUGFnYXRvPjEwLjAwPC9wYXlfaTpzaW5nb2xvSW1wb3J0b1BhZ2F0bz48cGF5X2k6Y29kaWNlRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjA8L3BheV9pOmNvZGljZUVzaXRvU2luZ29sb1BhZ2FtZW50bz48cGF5X2k6ZGF0YUVzaXRvU2luZ29sb1BhZ2FtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjwvcGF5X2k6ZGF0aVNpbmdvbGlQYWdhbWVudGk+PC9wYXlfaTpGbHVzc29SaXZlcnNhbWVudG8+                             | SIN_NIFR_63 |
            | xmlRendicontazione                    | PHBheV9pOkZsdXNzb1JpdmVyc2FtZW50byB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gRmx1c3NvUmVuZGljb250YXppb25lX3ZfMV8wXzEueHNkICIgeG1sbnM6cGF5X2k9Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiPjxwYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+MS4wPC9wYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+PHBheV9pOmlkZW50aWZpY2F0aXZvRmx1c3NvPjIwMjItMDctMDg1MDAwMDAwMDAwMS04ODUwPC9wYXlfaTppZGVudGlmaWNhdGl2b0ZsdXNzbz48cGF5X2k6ZGF0YU9yYUZsdXNzbz4yMDIyLTA3LTA4VDE0OjQzOjExLjMwMjwvcGF5X2k6ZGF0YU9yYUZsdXNzbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+SVVWMjk2Ny0yMDIyLTA3LTA4LTE0OjQzOjExLjMwMjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+PHBheV9pOmRhdGFSZWdvbGFtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhUmVnb2xhbWVudG8+PHBheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb01pdHRlbnRlPjxwYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+PHBheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz41MDAwMDAwMDAwMTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvTWl0dGVudGU+PHBheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT5kZW5NaXR0XzE8L3BheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT48L3BheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+QklDSURQU1A8L3BheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+PHBheV9pOmlzdGl0dXRvUmljZXZlbnRlPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RzwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz48cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPmNvZElkVW5pdl8yPC9wYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PCEtLXBheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGU+ZGVuUmljXzI8L3BheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGUtLT48L3BheV9pOmlzdGl0dXRvUmljZXZlbnRlPjxwYXlfaTpudW1lcm9Ub3RhbGVQYWdhbWVudGk+MTwvcGF5X2k6bnVtZXJvVG90YWxlUGFnYW1lbnRpPjxwYXlfaTppbXBvcnRvVG90YWxlUGFnYW1lbnRpPjIwLjAwPC9wYXlfaTppbXBvcnRvVG90YWxlUGFnYW1lbnRpPjxwYXlfaTpkYXRpU2luZ29saVBhZ2FtZW50aT48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FtZW50bz5JVVYyOTY3LTIwMjItMDctMDgtMTQ6NDM6MTEuMzAyPC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW1lbnRvPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaXNjb3NzaW9uZT5JVVYyOTY3LTIwMjItMDctMDgtMTQ6NDM6MTEuMzAyPC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaXNjb3NzaW9uZT48cGF5X2k6aW5kaWNlRGF0aVNpbmdvbG9QYWdhbWVudG8+MTwvcGF5X2k6aW5kaWNlRGF0aVNpbmdvbG9QYWdhbWVudG8+PHBheV9pOnNpbmdvbG9JbXBvcnRvUGFnYXRvPjEwLjAwPC9wYXlfaTpzaW5nb2xvSW1wb3J0b1BhZ2F0bz48cGF5X2k6Y29kaWNlRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjA8L3BheV9pOmNvZGljZUVzaXRvU2luZ29sb1BhZ2FtZW50bz48cGF5X2k6ZGF0YUVzaXRvU2luZ29sb1BhZ2FtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjwvcGF5X2k6ZGF0aVNpbmdvbGlQYWdhbWVudGk+PC9wYXlfaTpGbHVzc29SaXZlcnNhbWVudG8+                             | SIN_NIFR_76 |
            | xmlRendicontazione                    | PHBheV9pOkZsdXNzb1JpdmVyc2FtZW50byB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gRmx1c3NvUmVuZGljb250YXppb25lX3ZfMV8wXzEueHNkICIgeG1sbnM6cGF5X2k9Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiPjxwYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+MS4wPC9wYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+PHBheV9pOmlkZW50aWZpY2F0aXZvRmx1c3NvPjIwMjItMDctMDg1MDAwMDAwMDAwMS02ODAyPC9wYXlfaTppZGVudGlmaWNhdGl2b0ZsdXNzbz48cGF5X2k6ZGF0YU9yYUZsdXNzbz4yMDIyLTA3LTA4VDE0OjQzOjEzLjQzNTwvcGF5X2k6ZGF0YU9yYUZsdXNzbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+SVVWMTA1Mi0yMDIyLTA3LTA4LTE0OjQzOjEzLjQzNTwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+PHBheV9pOmRhdGFSZWdvbGFtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhUmVnb2xhbWVudG8+PHBheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb01pdHRlbnRlPjxwYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+PHBheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz41MDAwMDAwMDAwMTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvTWl0dGVudGU+PHBheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT5kZW5NaXR0XzE8L3BheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT48L3BheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+QklDSURQU1A8L3BheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+PHBheV9pOmlzdGl0dXRvUmljZXZlbnRlPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RzwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz48cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPmNvZElkVW5pdl8yPC9wYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PHBheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGU+ZGVuUmljXzI8L3BheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGU+PC9wYXlfaTppc3RpdHV0b1JpY2V2ZW50ZT48cGF5X2k6bnVtZXJvVG90YWxlUGFnYW1lbnRpPjE8L3BheV9pOm51bWVyb1RvdGFsZVBhZ2FtZW50aT48cGF5X2k6aW1wb3J0b1RvdGFsZVBhZ2FtZW50aT4wLjAwPC9wYXlfaTppbXBvcnRvVG90YWxlUGFnYW1lbnRpPjxwYXlfaTpkYXRpU2luZ29saVBhZ2FtZW50aT48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FtZW50bz5JVVYxMDUyLTIwMjItMDctMDgtMTQ6NDM6MTMuNDM1PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29WZXJzYW1lbnRvPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaXNjb3NzaW9uZT5JVVYxMDUyLTIwMjItMDctMDgtMTQ6NDM6MTMuNDM1PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaXNjb3NzaW9uZT48cGF5X2k6aW5kaWNlRGF0aVNpbmdvbG9QYWdhbWVudG8+MTwvcGF5X2k6aW5kaWNlRGF0aVNpbmdvbG9QYWdhbWVudG8+PHBheV9pOnNpbmdvbG9JbXBvcnRvUGFnYXRvPjEwLjAwPC9wYXlfaTpzaW5nb2xvSW1wb3J0b1BhZ2F0bz48cGF5X2k6Y29kaWNlRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjA8L3BheV9pOmNvZGljZUVzaXRvU2luZ29sb1BhZ2FtZW50bz48cGF5X2k6ZGF0YUVzaXRvU2luZ29sb1BhZ2FtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjwvcGF5X2k6ZGF0aVNpbmdvbGlQYWdhbWVudGk+PC9wYXlfaTpGbHVzc29SaXZlcnNhbWVudG8+                             | SIN_NIFR_85 |
            | xmlRendicontazione                    | PHBheV9pOkZsdXNzb1JpdmVyc2FtZW50byB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8gRmx1c3NvUmVuZGljb250YXppb25lX3ZfMV8wXzEueHNkICIgeG1sbnM6cGF5X2k9Imh0dHA6Ly93d3cuZGlnaXRwYS5nb3YuaXQvc2NoZW1hcy8yMDExL1BhZ2FtZW50aS8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiPjxwYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+MS4wPC9wYXlfaTp2ZXJzaW9uZU9nZ2V0dG8+PHBheV9pOmlkZW50aWZpY2F0aXZvRmx1c3NvPjIwMjItMDctMDg1MDAwMDAwMDAwMS0yODE0PC9wYXlfaTppZGVudGlmaWNhdGl2b0ZsdXNzbz48cGF5X2k6ZGF0YU9yYUZsdXNzbz4yMDIyLTA3LTA4VDE0OjQzOjE2LjIyMDwvcGF5X2k6ZGF0YU9yYUZsdXNzbz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+SVVWNjI5My0yMDIyLTA3LTA4LTE0OjQzOjE2LjIyMDwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmVnb2xhbWVudG8+PHBheV9pOmRhdGFSZWdvbGFtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhUmVnb2xhbWVudG8+PHBheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb01pdHRlbnRlPjxwYXlfaTp0aXBvSWRlbnRpZmljYXRpdm9Vbml2b2NvPkc8L3BheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+PHBheV9pOmNvZGljZUlkZW50aWZpY2F0aXZvVW5pdm9jbz41MDAwMDAwMDAwMTwvcGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPjwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvTWl0dGVudGU+PHBheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT5kZW5NaXR0XzE8L3BheV9pOmRlbm9taW5hemlvbmVNaXR0ZW50ZT48L3BheV9pOmlzdGl0dXRvTWl0dGVudGU+PHBheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+QklDSURQU1A8L3BheV9pOmNvZGljZUJpY0JhbmNhRGlSaXZlcnNhbWVudG8+PHBheV9pOmlzdGl0dXRvUmljZXZlbnRlPjxwYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PHBheV9pOnRpcG9JZGVudGlmaWNhdGl2b1VuaXZvY28+RzwvcGF5X2k6dGlwb0lkZW50aWZpY2F0aXZvVW5pdm9jbz48cGF5X2k6Y29kaWNlSWRlbnRpZmljYXRpdm9Vbml2b2NvPmNvZElkVW5pdl8yPC9wYXlfaTpjb2RpY2VJZGVudGlmaWNhdGl2b1VuaXZvY28+PC9wYXlfaTppZGVudGlmaWNhdGl2b1VuaXZvY29SaWNldmVudGU+PHBheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGU+ZGVuUmljXzI8L3BheV9pOmRlbm9taW5hemlvbmVSaWNldmVudGU+PC9wYXlfaTppc3RpdHV0b1JpY2V2ZW50ZT48cGF5X2k6bnVtZXJvVG90YWxlUGFnYW1lbnRpPjE8L3BheV9pOm51bWVyb1RvdGFsZVBhZ2FtZW50aT48cGF5X2k6aW1wb3J0b1RvdGFsZVBhZ2FtZW50aT4yMC4wMDwvcGF5X2k6aW1wb3J0b1RvdGFsZVBhZ2FtZW50aT48cGF5X2k6ZGF0aVNpbmdvbGlQYWdhbWVudGk+PHBheV9pOmlkZW50aWZpY2F0aXZvVW5pdm9jb1ZlcnNhbWVudG8+SVVWNjI5My0yMDIyLTA3LTA4LTE0OjQzOjE2LjIyMDwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvVmVyc2FtZW50bz48cGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmlzY29zc2lvbmU+SVVWNjI5My0yMDIyLTA3LTA4LTE0OjQzOjE2LjIyMDwvcGF5X2k6aWRlbnRpZmljYXRpdm9Vbml2b2NvUmlzY29zc2lvbmU+PCEtLXBheV9pOmluZGljZURhdGlTaW5nb2xvUGFnYW1lbnRvPjE8L3BheV9pOmluZGljZURhdGlTaW5nb2xvUGFnYW1lbnRvLS0+PHBheV9pOnNpbmdvbG9JbXBvcnRvUGFnYXRvPjEwLjAwPC9wYXlfaTpzaW5nb2xvSW1wb3J0b1BhZ2F0bz48cGF5X2k6Y29kaWNlRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjA8L3BheV9pOmNvZGljZUVzaXRvU2luZ29sb1BhZ2FtZW50bz48cGF5X2k6ZGF0YUVzaXRvU2luZ29sb1BhZ2FtZW50bz4yMDIyLTA3LTA4PC9wYXlfaTpkYXRhRXNpdG9TaW5nb2xvUGFnYW1lbnRvPjwvcGF5X2k6ZGF0aVNpbmdvbGlQYWdhbWVudGk+PC9wYXlfaTpGbHVzc29SaXZlcnNhbWVudG8+                             | SIN_NIFR_97 |