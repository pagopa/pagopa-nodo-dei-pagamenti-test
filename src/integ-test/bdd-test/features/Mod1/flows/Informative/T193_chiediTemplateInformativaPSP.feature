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
        And check xmlTemplateInformativa is PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/PjxpbmZvcm1hdGl2YVBTUCB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIj48aWRlbnRpZmljYXRpdm9GbHVzc28+REEgQ09NUElMQVJFIChmb3JtYXRvOiBbSURQU1BdX2RkLW1tLXl5eXkgLSBlc2VtcGlvOiBFU0VNUElPXzMxLTEyLTIwMDEpPC9pZGVudGlmaWNhdGl2b0ZsdXNzbz48aWRlbnRpZmljYXRpdm9QU1A+REEgQ09NUElMQVJFPC9pZGVudGlmaWNhdGl2b1BTUD48cmFnaW9uZVNvY2lhbGU+REEgQ09NUElMQVJFPC9yYWdpb25lU29jaWFsZT48Y29kaWNlQUJJPjk4NzY1PC9jb2RpY2VBQkk+PGNvZGljZUJJQz5UQkQ8L2NvZGljZUJJQz48bXliYW5rSURWUz5DVDAwMDA3NTwvbXliYW5rSURWUz48aW5mb3JtYXRpdmFNYXN0ZXI+PGRhdGFQdWJibGljYXppb25lPkRBIENPTVBJTEFSRTwvZGF0YVB1YmJsaWNhemlvbmU+PGRhdGFJbml6aW9WYWxpZGl0YT5EQSBDT01QSUxBUkU8L2RhdGFJbml6aW9WYWxpZGl0YT48dXJsSW5mb3JtYXppb25pUFNQPkRBIENPTVBJTEFSRTwvdXJsSW5mb3JtYXppb25pUFNQPjx1cmxJbmZvcm1hdGl2YVBTUD5EQSBDT01QSUxBUkU8L3VybEluZm9ybWF0aXZhUFNQPjx1cmxDb252ZW56aW9uaVBTUD5EQSBDT01QSUxBUkU8L3VybENvbnZlbnppb25pUFNQPjxzdG9ybm9QYWdhbWVudG8+MDwvc3Rvcm5vUGFnYW1lbnRvPjxtYXJjYUJvbGxvRGlnaXRhbGU+MDwvbWFyY2FCb2xsb0RpZ2l0YWxlPjxsb2dvUFNQPkRBIENPTVBJTEFSRTwvbG9nb1BTUD48L2luZm9ybWF0aXZhTWFzdGVyPjxsaXN0YUluZm9ybWF0aXZhRGV0YWlsPjxpbmZvcm1hdGl2YURldGFpbD48aWRlbnRpZmljYXRpdm9JbnRlcm1lZGlhcmlvPkRBIENPTVBJTEFSRTwvaWRlbnRpZmljYXRpdm9JbnRlcm1lZGlhcmlvPjxpZGVudGlmaWNhdGl2b0NhbmFsZT5EQSBDT01QSUxBUkU8L2lkZW50aWZpY2F0aXZvQ2FuYWxlPjx0aXBvVmVyc2FtZW50bz5CQlQ8L3RpcG9WZXJzYW1lbnRvPjxtb2RlbGxvUGFnYW1lbnRvPjA8L21vZGVsbG9QYWdhbWVudG8+PHByaW9yaXRhPkRBIENPTVBJTEFSRTwvcHJpb3JpdGE+PGNhbmFsZUFwcD5EQSBDT01QSUxBUkU8L2NhbmFsZUFwcD48aWRlbnRpZmljYXppb25lU2Vydml6aW8+PG5vbWVTZXJ2aXppbz5EQSBDT01QSUxBUkU8L25vbWVTZXJ2aXppbz48bG9nb1NlcnZpemlvPkRBIENPTVBJTEFSRTwvbG9nb1NlcnZpemlvPjwvaWRlbnRpZmljYXppb25lU2Vydml6aW8+PGxpc3RhSW5mb3JtYXppb25pU2Vydml6aW8+PGluZm9ybWF6aW9uaVNlcnZpemlvPjxjb2RpY2VMaW5ndWE+SVQ8L2NvZGljZUxpbmd1YT48ZGVzY3JpemlvbmVTZXJ2aXppbz5EQSBDT01QSUxBUkU8L2Rlc2NyaXppb25lU2Vydml6aW8+PGxpbWl0YXppb25pU2Vydml6aW8+REEgQ09NUElMQVJFPC9saW1pdGF6aW9uaVNlcnZpemlvPjx1cmxJbmZvcm1hemlvbmlDYW5hbGU+REEgQ09NUElMQVJFPC91cmxJbmZvcm1hemlvbmlDYW5hbGU+PC9pbmZvcm1hemlvbmlTZXJ2aXppbz48aW5mb3JtYXppb25pU2Vydml6aW8+PGNvZGljZUxpbmd1YT5JVDwvY29kaWNlTGluZ3VhPjxkZXNjcml6aW9uZVNlcnZpemlvPkRBIENPTVBJTEFSRTwvZGVzY3JpemlvbmVTZXJ2aXppbz48bGltaXRhemlvbmlTZXJ2aXppbz5EQSBDT01QSUxBUkU8L2xpbWl0YXppb25pU2Vydml6aW8+PHVybEluZm9ybWF6aW9uaUNhbmFsZT5EQSBDT01QSUxBUkU8L3VybEluZm9ybWF6aW9uaUNhbmFsZT48L2luZm9ybWF6aW9uaVNlcnZpemlvPjxpbmZvcm1hemlvbmlTZXJ2aXppbz48Y29kaWNlTGluZ3VhPklUPC9jb2RpY2VMaW5ndWE+PGRlc2NyaXppb25lU2Vydml6aW8+REEgQ09NUElMQVJFPC9kZXNjcml6aW9uZVNlcnZpemlvPjxsaW1pdGF6aW9uaVNlcnZpemlvPkRBIENPTVBJTEFSRTwvbGltaXRhemlvbmlTZXJ2aXppbz48dXJsSW5mb3JtYXppb25pQ2FuYWxlPkRBIENPTVBJTEFSRTwvdXJsSW5mb3JtYXppb25pQ2FuYWxlPjwvaW5mb3JtYXppb25pU2Vydml6aW8+PGluZm9ybWF6aW9uaVNlcnZpemlvPjxjb2RpY2VMaW5ndWE+SVQ8L2NvZGljZUxpbmd1YT48ZGVzY3JpemlvbmVTZXJ2aXppbz5EQSBDT01QSUxBUkU8L2Rlc2NyaXppb25lU2Vydml6aW8+PGxpbWl0YXppb25pU2Vydml6aW8+REEgQ09NUElMQVJFPC9saW1pdGF6aW9uaVNlcnZpemlvPjx1cmxJbmZvcm1hemlvbmlDYW5hbGU+REEgQ09NUElMQVJFPC91cmxJbmZvcm1hemlvbmlDYW5hbGU+PC9pbmZvcm1hemlvbmlTZXJ2aXppbz48aW5mb3JtYXppb25pU2Vydml6aW8+PGNvZGljZUxpbmd1YT5JVDwvY29kaWNlTGluZ3VhPjxkZXNjcml6aW9uZVNlcnZpemlvPkRBIENPTVBJTEFSRTwvZGVzY3JpemlvbmVTZXJ2aXppbz48bGltaXRhemlvbmlTZXJ2aXppbz5EQSBDT01QSUxBUkU8L2xpbWl0YXppb25pU2Vydml6aW8+PHVybEluZm9ybWF6aW9uaUNhbmFsZT5EQSBDT01QSUxBUkU8L3VybEluZm9ybWF6aW9uaUNhbmFsZT48L2luZm9ybWF6aW9uaVNlcnZpemlvPjwvbGlzdGFJbmZvcm1hemlvbmlTZXJ2aXppbz48bGlzdGFQYXJvbGVDaGlhdmU+PHBhcm9sZUNoaWF2ZT5EQSBDT01QSUxBUkU8L3Bhcm9sZUNoaWF2ZT48cGFyb2xlQ2hpYXZlPkRBIENPTVBJTEFSRTwvcGFyb2xlQ2hpYXZlPjxwYXJvbGVDaGlhdmU+REEgQ09NUElMQVJFPC9wYXJvbGVDaGlhdmU+PC9saXN0YVBhcm9sZUNoaWF2ZT48Y29zdGlTZXJ2aXppbz48dGlwb0Nvc3RvVHJhbnNhemlvbmU+MDwvdGlwb0Nvc3RvVHJhbnNhemlvbmU+PHRpcG9Db21taXNzaW9uZT4wPC90aXBvQ29tbWlzc2lvbmU+PGxpc3RhRmFzY2VDb3N0b1NlcnZpemlvPjxmYXNjaWFDb3N0b1NlcnZpemlvPjxpbXBvcnRvTWFzc2ltb0Zhc2NpYT5EQSBDT01QSUxBUkU8L2ltcG9ydG9NYXNzaW1vRmFzY2lhPjxjb3N0b0Zpc3NvPkRBIENPTVBJTEFSRTwvY29zdG9GaXNzbz48L2Zhc2NpYUNvc3RvU2Vydml6aW8+PGZhc2NpYUNvc3RvU2Vydml6aW8+PGltcG9ydG9NYXNzaW1vRmFzY2lhPkRBIENPTVBJTEFSRTwvaW1wb3J0b01hc3NpbW9GYXNjaWE+PGNvc3RvRmlzc28+REEgQ09NUElMQVJFPC9jb3N0b0Zpc3NvPjwvZmFzY2lhQ29zdG9TZXJ2aXppbz48ZmFzY2lhQ29zdG9TZXJ2aXppbz48aW1wb3J0b01hc3NpbW9GYXNjaWE+REEgQ09NUElMQVJFPC9pbXBvcnRvTWFzc2ltb0Zhc2NpYT48Y29zdG9GaXNzbz5EQSBDT01QSUxBUkU8L2Nvc3RvRmlzc28+PC9mYXNjaWFDb3N0b1NlcnZpemlvPjwvbGlzdGFGYXNjZUNvc3RvU2Vydml6aW8+PC9jb3N0aVNlcnZpemlvPjwvaW5mb3JtYXRpdmFEZXRhaWw+PC9saXN0YUluZm9ybWF0aXZhRGV0YWlsPjwvaW5mb3JtYXRpdmFQU1A+ of nodoChiediTemplateInformativaPSP response


@runnable 
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