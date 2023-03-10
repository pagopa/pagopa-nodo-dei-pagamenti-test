Feature: process tests for nodoChiediTemplateInformativaPSP

    Background:
        Given systems up
@runnable
    Scenario: Send nodoChiediTemplateInformativaPSP
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediTemplateInformativaPSP>
                    <identificativoPSP>idPsp1</identificativoPSP>
                    <identificativoIntermediarioPSP>70000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>70000000001_04</identificativoCanale>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check xmlTemplateInformativa field exists in nodoChiediTemplateInformativaPSP response
        And check ppt:nodoChiediTemplateInformativaPSPRisposta field exists in nodoChiediTemplateInformativaPSP response
        And check xmlTemplateInformativa is PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIiA/PjxpbmZvcm1hdGl2YVBTUCB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIj48aWRlbnRpZmljYXRpdm9GbHVzc28+REEgQ09NUElMQVJFIChmb3JtYXRvOiBbSURQU1BdX2RkLW1tLXl5eXkgLSBlc2VtcGlvOiBFU0VNUElPXzMxLTEyLTIwMDEpPC9pZGVudGlmaWNhdGl2b0ZsdXNzbz48aWRlbnRpZmljYXRpdm9QU1A+REEgQ09NUElMQVJFPC9pZGVudGlmaWNhdGl2b1BTUD48cmFnaW9uZVNvY2lhbGU+REEgQ09NUElMQVJFPC9yYWdpb25lU29jaWFsZT48Y29kaWNlQUJJPjk4NzY1PC9jb2RpY2VBQkk+PGNvZGljZUJJQz5UQkQ8L2NvZGljZUJJQz48bXliYW5rSURWUz5DVDAwMDA3NTwvbXliYW5rSURWUz48aW5mb3JtYXRpdmFNYXN0ZXI+PGRhdGFQdWJibGljYXppb25lPkRBIENPTVBJTEFSRSAoZm9ybWF0bzogeXl5eS1tbS1kZFRoaDptbTpzcyAtIGVzZW1waW86IDIwMDEtMTItMzFUMTI6MDA6MDApPC9kYXRhUHViYmxpY2F6aW9uZT48ZGF0YUluaXppb1ZhbGlkaXRhPkRBIENPTVBJTEFSRSAoZm9ybWF0bzogeXl5eS1tbS1kZFRoaDptbTpzcyAtIGVzZW1waW86IDIwMDEtMTItMzFUMTI6MDA6MDApPC9kYXRhSW5pemlvVmFsaWRpdGE+PHVybEluZm9ybWF6aW9uaVBTUD5EQSBDT01QSUxBUkU8L3VybEluZm9ybWF6aW9uaVBTUD48dXJsSW5mb3JtYXRpdmFQU1A+REEgQ09NUElMQVJFPC91cmxJbmZvcm1hdGl2YVBTUD48dXJsQ29udmVuemlvbmlQU1A+REEgQ09NUElMQVJFPC91cmxDb252ZW56aW9uaVBTUD48c3Rvcm5vUGFnYW1lbnRvPjA8L3N0b3Jub1BhZ2FtZW50bz48bWFyY2FCb2xsb0RpZ2l0YWxlPjA8L21hcmNhQm9sbG9EaWdpdGFsZT48bG9nb1BTUD5EQSBDT01QSUxBUkU8L2xvZ29QU1A+PC9pbmZvcm1hdGl2YU1hc3Rlcj48bGlzdGFJbmZvcm1hdGl2YURldGFpbD48aW5mb3JtYXRpdmFEZXRhaWw+PGlkZW50aWZpY2F0aXZvSW50ZXJtZWRpYXJpbz5EQSBDT01QSUxBUkU8L2lkZW50aWZpY2F0aXZvSW50ZXJtZWRpYXJpbz48aWRlbnRpZmljYXRpdm9DYW5hbGU+REEgQ09NUElMQVJFPC9pZGVudGlmaWNhdGl2b0NhbmFsZT48dGlwb1ZlcnNhbWVudG8+QkJUPC90aXBvVmVyc2FtZW50bz48bW9kZWxsb1BhZ2FtZW50bz4wPC9tb2RlbGxvUGFnYW1lbnRvPjxwcmlvcml0YT5EQSBDT01QSUxBUkU8L3ByaW9yaXRhPjxjYW5hbGVBcHA+REEgQ09NUElMQVJFPC9jYW5hbGVBcHA+PGlkZW50aWZpY2F6aW9uZVNlcnZpemlvPjxub21lU2Vydml6aW8+REEgQ09NUElMQVJFPC9ub21lU2Vydml6aW8+PGxvZ29TZXJ2aXppbz5EQSBDT01QSUxBUkU8L2xvZ29TZXJ2aXppbz48L2lkZW50aWZpY2F6aW9uZVNlcnZpemlvPjxsaXN0YUluZm9ybWF6aW9uaVNlcnZpemlvPjxpbmZvcm1hemlvbmlTZXJ2aXppbz48Y29kaWNlTGluZ3VhPklUPC9jb2RpY2VMaW5ndWE+PGRlc2NyaXppb25lU2Vydml6aW8+REEgQ09NUElMQVJFPC9kZXNjcml6aW9uZVNlcnZpemlvPjxkaXNwb25pYmlsaXRhU2Vydml6aW8+REEgQ09NUElMQVJFPC9kaXNwb25pYmlsaXRhU2Vydml6aW8+PGxpbWl0YXppb25pU2Vydml6aW8+REEgQ09NUElMQVJFPC9saW1pdGF6aW9uaVNlcnZpemlvPjx1cmxJbmZvcm1hemlvbmlDYW5hbGU+REEgQ09NUElMQVJFPC91cmxJbmZvcm1hemlvbmlDYW5hbGU+PC9pbmZvcm1hemlvbmlTZXJ2aXppbz48aW5mb3JtYXppb25pU2Vydml6aW8+PGNvZGljZUxpbmd1YT5FTjwvY29kaWNlTGluZ3VhPjxkZXNjcml6aW9uZVNlcnZpemlvPkRBIENPTVBJTEFSRTwvZGVzY3JpemlvbmVTZXJ2aXppbz48ZGlzcG9uaWJpbGl0YVNlcnZpemlvPkRBIENPTVBJTEFSRTwvZGlzcG9uaWJpbGl0YVNlcnZpemlvPjxsaW1pdGF6aW9uaVNlcnZpemlvPkRBIENPTVBJTEFSRTwvbGltaXRhemlvbmlTZXJ2aXppbz48dXJsSW5mb3JtYXppb25pQ2FuYWxlPkRBIENPTVBJTEFSRTwvdXJsSW5mb3JtYXppb25pQ2FuYWxlPjwvaW5mb3JtYXppb25pU2Vydml6aW8+PGluZm9ybWF6aW9uaVNlcnZpemlvPjxjb2RpY2VMaW5ndWE+REU8L2NvZGljZUxpbmd1YT48ZGVzY3JpemlvbmVTZXJ2aXppbz5EQSBDT01QSUxBUkU8L2Rlc2NyaXppb25lU2Vydml6aW8+PGRpc3BvbmliaWxpdGFTZXJ2aXppbz5EQSBDT01QSUxBUkU8L2Rpc3BvbmliaWxpdGFTZXJ2aXppbz48bGltaXRhemlvbmlTZXJ2aXppbz5EQSBDT01QSUxBUkU8L2xpbWl0YXppb25pU2Vydml6aW8+PHVybEluZm9ybWF6aW9uaUNhbmFsZT5EQSBDT01QSUxBUkU8L3VybEluZm9ybWF6aW9uaUNhbmFsZT48L2luZm9ybWF6aW9uaVNlcnZpemlvPjxpbmZvcm1hemlvbmlTZXJ2aXppbz48Y29kaWNlTGluZ3VhPkZSPC9jb2RpY2VMaW5ndWE+PGRlc2NyaXppb25lU2Vydml6aW8+REEgQ09NUElMQVJFPC9kZXNjcml6aW9uZVNlcnZpemlvPjxkaXNwb25pYmlsaXRhU2Vydml6aW8+REEgQ09NUElMQVJFPC9kaXNwb25pYmlsaXRhU2Vydml6aW8+PGxpbWl0YXppb25pU2Vydml6aW8+REEgQ09NUElMQVJFPC9saW1pdGF6aW9uaVNlcnZpemlvPjx1cmxJbmZvcm1hemlvbmlDYW5hbGU+REEgQ09NUElMQVJFPC91cmxJbmZvcm1hemlvbmlDYW5hbGU+PC9pbmZvcm1hemlvbmlTZXJ2aXppbz48aW5mb3JtYXppb25pU2Vydml6aW8+PGNvZGljZUxpbmd1YT5TTDwvY29kaWNlTGluZ3VhPjxkZXNjcml6aW9uZVNlcnZpemlvPkRBIENPTVBJTEFSRTwvZGVzY3JpemlvbmVTZXJ2aXppbz48ZGlzcG9uaWJpbGl0YVNlcnZpemlvPkRBIENPTVBJTEFSRTwvZGlzcG9uaWJpbGl0YVNlcnZpemlvPjxsaW1pdGF6aW9uaVNlcnZpemlvPkRBIENPTVBJTEFSRTwvbGltaXRhemlvbmlTZXJ2aXppbz48dXJsSW5mb3JtYXppb25pQ2FuYWxlPkRBIENPTVBJTEFSRTwvdXJsSW5mb3JtYXppb25pQ2FuYWxlPjwvaW5mb3JtYXppb25pU2Vydml6aW8+PC9saXN0YUluZm9ybWF6aW9uaVNlcnZpemlvPjxsaXN0YVBhcm9sZUNoaWF2ZT48cGFyb2xlQ2hpYXZlPkRBIENPTVBJTEFSRTwvcGFyb2xlQ2hpYXZlPjxwYXJvbGVDaGlhdmU+REEgQ09NUElMQVJFPC9wYXJvbGVDaGlhdmU+PHBhcm9sZUNoaWF2ZT5EQSBDT01QSUxBUkU8L3Bhcm9sZUNoaWF2ZT48L2xpc3RhUGFyb2xlQ2hpYXZlPjxjb3N0aVNlcnZpemlvPjx0aXBvQ29zdG9UcmFuc2F6aW9uZT4wPC90aXBvQ29zdG9UcmFuc2F6aW9uZT48dGlwb0NvbW1pc3Npb25lPjA8L3RpcG9Db21taXNzaW9uZT48bGlzdGFGYXNjZUNvc3RvU2Vydml6aW8+PGZhc2NpYUNvc3RvU2Vydml6aW8+PGltcG9ydG9NYXNzaW1vRmFzY2lhPkRBIENPTVBJTEFSRTwvaW1wb3J0b01hc3NpbW9GYXNjaWE+PGNvc3RvRmlzc28+REEgQ09NUElMQVJFPC9jb3N0b0Zpc3NvPjx2YWxvcmVDb21taXNzaW9uZT5EQSBDT01QSUxBUkU8L3ZhbG9yZUNvbW1pc3Npb25lPjwvZmFzY2lhQ29zdG9TZXJ2aXppbz48ZmFzY2lhQ29zdG9TZXJ2aXppbz48aW1wb3J0b01hc3NpbW9GYXNjaWE+REEgQ09NUElMQVJFPC9pbXBvcnRvTWFzc2ltb0Zhc2NpYT48Y29zdG9GaXNzbz5EQSBDT01QSUxBUkU8L2Nvc3RvRmlzc28+PHZhbG9yZUNvbW1pc3Npb25lPkRBIENPTVBJTEFSRTwvdmFsb3JlQ29tbWlzc2lvbmU+PC9mYXNjaWFDb3N0b1NlcnZpemlvPjxmYXNjaWFDb3N0b1NlcnZpemlvPjxpbXBvcnRvTWFzc2ltb0Zhc2NpYT5EQSBDT01QSUxBUkU8L2ltcG9ydG9NYXNzaW1vRmFzY2lhPjxjb3N0b0Zpc3NvPkRBIENPTVBJTEFSRTwvY29zdG9GaXNzbz48dmFsb3JlQ29tbWlzc2lvbmU+REEgQ09NUElMQVJFPC92YWxvcmVDb21taXNzaW9uZT48L2Zhc2NpYUNvc3RvU2Vydml6aW8+PC9saXN0YUZhc2NlQ29zdG9TZXJ2aXppbz48L2Nvc3RpU2Vydml6aW8+PC9pbmZvcm1hdGl2YURldGFpbD48L2xpc3RhSW5mb3JtYXRpdmFEZXRhaWw+PC9pbmZvcm1hdGl2YVBTUD4= of nodoChiediTemplateInformativaPSP response

@runnable @testdev
    Scenario: Send second nodoChiediTemplateInformativaPSP
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediTemplateInformativaPSP>
                    <identificativoPSP>IDPSPFNZ</identificativoPSP>
                    <identificativoIntermediarioPSP>91000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>91000000001_03</identificativoCanale>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check xmlTemplateInformativa field exists in nodoChiediTemplateInformativaPSP response
        And check ppt:nodoChiediTemplateInformativaPSPRisposta field exists in nodoChiediTemplateInformativaPSP response
        And check fault field not exists in nodoChiediTemplateInformativaPSP response