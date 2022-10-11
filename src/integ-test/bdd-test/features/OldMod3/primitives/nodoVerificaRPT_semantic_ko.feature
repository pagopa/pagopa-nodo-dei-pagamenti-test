Feature: Semantic checks KO for nodoVerificaRPT
    Background:
        Given systems up
        And initial XML nodoVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoVerificaRPT>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#id_broker#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT><qrc:QrCode>
            <qrc:CF>#id_broker#</qrc:CF>
            <qrc:CodStazPA>#cod_segr#</qrc:CodStazPA>
            <qrc:AuxDigit>0</qrc:AuxDigit>
            <qrc:CodIUV>#iuv#</qrc:CodIUV>
            </qrc:QrCode></codiceIdRPT>
            </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
     
    Scenario Outline: Check faultCode error on non-existent or invalid field
        Given <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is <resp_error> of nodoVerificaRPT response
        Examples:
            | field                          | value              | resp_error                         | soapUI test |
            | identificativoPSP              | pspUnknown         | PPT_PSP_SCONOSCIUTO                | VRPTSEM1    |
            | identificativoPSP              | NOT_ENABLED        | PPT_PSP_DISABILITATO               | VRPTSEM2    |
            | identificativoIntermediarioPSP | brokerPspUnknown   | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  | VRPTSEM3    |
            | identificativoIntermediarioPSP | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO | VRPTSEM4    |
            | identificativoCanale           | channelUnknown     | PPT_CANALE_SCONOSCIUTO             | VRPTSEM5    |
            | identificativoCanale           | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO            | VRPTSEM6    |
            | password                       | test_wrong_pwd     | PPT_AUTENTICAZIONE                 | VRPTSEM7    |
            | codificaInfrastrutturaPSP      | codificaErrata     | PPT_CODIFICA_PSP_SCONOSCIUTA       | VRPTSEM8    |

    Scenario Outline: Check faultCode PPT_SEMANTICA on invalid body element
        Given <field_1> with <value_1> in nodoVerificaRPT
        And <field_2> with <value_2> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SEMANTICA of nodoVerificaRPT response
        Examples:
            | field_1      | value_1 | field_2    | value_2           | soapUI test |
            | qrc:AuxDigit | 0       | qrc:CodIUV | 12345678901234567 | VRPTSEM9    |
            | qrc:AuxDigit | 1       | qrc:CodIUV | 123456789012345   | VRPTSEM10   |

    Scenario Outline: Check faultCode error on invalid iuv
        Given <field_1> with <value_1> in nodoVerificaRPT
        And <field_2> with <value_2> in nodoVerificaRPT
        And <field_3> with <value_3> in nodoVerificaRPT
        And <field_4> with <value_4> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is <resp_error> of nodoVerificaRPT response
        Examples:
            | field_1      | value_1 | field_2         | value_2    | field_3          |value_3          |field_4 |value_4 | resp_error                       |soapUI test |
            | qrc:AuxDigit | 3       | qrc:CodStazPA   | None       |   qrc:CodIUV     |00012711162144900|qrc:CF |#id_broker_old#|PPT_STAZIONE_INT_PA_SCONOSCIUTA  |VRPTSEM11   |
    
    Scenario: Check faultCode error PPT_DOMINIO_SCONOSCIUTO [VRPTSEM13 ]
        Given initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoVerificaRPT>
                <identificativoPSP>40000000001</identificativoPSP>
                <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                <identificativoCanale>40000000001_01</identificativoCanale>
                <password>pwdpwdpwd</password>
                <codiceContestoPagamento>130191402011917</codiceContestoPagamento>
                <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                <codiceIdRPT><qrc:QrCode>  <qrc:CF>11223344551</qrc:CF> <qrc:CodStazPA>02</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>015261508179300</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
            </ws:nodoVerificaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoVerificaRPT response

    Scenario: Check faultCode error PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE [VRPTSEM14 ]
        Given initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoVerificaRPT>
                <identificativoPSP>40000000001</identificativoPSP>
                <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                <identificativoCanale>40000000001_01</identificativoCanale>
                <password>pwdpwdpwd</password>
                <codiceContestoPagamento>irraggiungibile</codiceContestoPagamento>
                <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
                <codiceIdRPT><aim:aim128> <aim:CCPost>444444444444</aim:CCPost> <aim:CodStazPA>02</aim:CodStazPA> <aim:AuxDigit>0</aim:AuxDigit>  <aim:CodIUV>016101258167700</aim:CodIUV></aim:aim128></codiceIdRPT>
            </ws:nodoVerificaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of nodoVerificaRPT response

    Scenario: Check faultCode error PPT_STAZIONE_INT_PA_SCONOSCIUTA [VRPTSEM15 ]
        Given initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoVerificaRPT>
                <identificativoPSP>40000000001</identificativoPSP>
                <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                <identificativoCanale>40000000001_01</identificativoCanale>
                <password>pwdpwdpwd</password>
                <codiceContestoPagamento>122331398916990</codiceContestoPagamento>
                <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                <codiceIdRPT><qrc:QrCode>  <qrc:CF>44444444444</qrc:CF> <qrc:CodStazPA>98</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>014501764115600</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
            </ws:nodoVerificaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoVerificaRPT response
    
    Scenario Outline: Check faultCode error on unknown or invalid CodStazPA
        Given <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is <resp_error> of nodoVerificaRPT response
        Examples:
            | field         | value       | resp_error              | soapUI test |
            | qrc:CF        | 11111122222 | PPT_DOMINIO_SCONOSCIUTO | VRPTSEM16   |
            | qrc:CF        | 77777777778 | PPT_DOMINIO_SCONOSCIUTO | VRPTSEM17   |
            | qrc:CF        | 11111122222 | PPT_DOMINIO_SCONOSCIUTO | VRPTSEM18   |
            | qrc:CodStazPA | None        | PPT_SEMANTICA           | VRPTSEM19   |

    Scenario: Check faultCode error PPT_AUTORIZZAZIONE [VRPTSEM20 ]
        Given initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoVerificaRPT>
                    <identificativoPSP>40000000001</identificativoPSP>
                    <identificativoIntermediarioPSP>91000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>40000000001_01</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <codiceContestoPagamento>153041492411187</codiceContestoPagamento>
                    <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                    <codiceIdRPT><qrc:QrCode>  <qrc:CF>44444444444</qrc:CF> <qrc:CodStazPA>02</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>013601115164900</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
                </ws:nodoVerificaRPT>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTORIZZAZIONE of nodoVerificaRPT response


