Feature: response tests for paDemandPaymentNotice 930

    Background:
        Given systems up

    Scenario: demandPaymentNotice
        Given initial XML demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idSoggettoServizio>00042</idSoggettoServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgo8dGE6dmVpY29sb0NvblRhcmdhPgo8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPgo8dGE6dmVpY29sb1RhcmdhPkFCMzQ1Q0Q8L3RhOnZlaWNvbG9UYXJnYT4KPC90YTp2ZWljb2xvQ29uVGFyZ2E+CjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paDemandPaymentNotice
        Given initial XML paDemandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
            <outcome>OK</outcome>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
            <paymentList>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <paymentDescription>paymentDescription</paymentDescription>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <companyName>companyName</companyName>
            <officeName>officeName</officeName>
            </paf:paDemandPaymentNoticeResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paDemandPaymentNotice with 2 paymentList
        Given initial XML paDemandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
            <outcome>OK</outcome>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
            <paymentList>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <paymentList>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <paymentDescription>paymentDescription</paymentDescription>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <companyName>companyName</companyName>
            <officeName>officeName</officeName>
            </paf:paDemandPaymentNoticeResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paDemandPaymentNotice with 2 paymentOptionDescription
        Given initial XML paDemandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
            <outcome>OK</outcome>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
            <paymentList>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <paymentDescription>paymentDescription</paymentDescription>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <companyName>companyName</companyName>
            <officeName>officeName</officeName>
            </paf:paDemandPaymentNoticeResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paDemandPaymentNotice KO
        Given initial XML paDemandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
            <outcome>KO</outcome>
            <fault>
            <faultCode>PAA_SEMANTICA</faultCode>
            <faultString>chiamata da rifiutare</faultString>
            <id>#creditor_institution_code#</id>
            <description>chiamata da rifiutare</description>
            </fault>
            </paf:paDemandPaymentNoticeResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
    @ALL @PRIMITIVE @NM4 
    Scenario Outline: Check paDemandPaymentNotice response with missing optional fields
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice scenario executed successfully
        And <elem> with <value> in paDemandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response
        Examples:
            | elem              | value | soapUI test  |
            | soapenv:Header    | None  | TRES_PDPN_01 |
            | dueDate           | None  | TRES_PDPN_39 |
            | detailDescription | None  | TRES_PDPN_42 |
            | officeName        | None  | TRES_PDPN_58 |

    # TRES_PDPN_02
    @ALL @PRIMITIVE @NM4 
    Scenario: TRES_PDPN_02
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response
    @ALL @PRIMITIVE @NM4 
    Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice scenario executed successfully
        And <elem> with <value> in paDemandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response
        Examples:
            | elem                              | value                                                                                                                                           | soapUI test  |
            | soapenv:Body                      | None                                                                                                                                            | TRES_PDPN_03 |
            | soapenv:Body                      | Empty                                                                                                                                           | TRES_PDPN_04 |
            | paf:paDemandPaymentNoticeResponse | None                                                                                                                                            | TRES_PDPN_05 |
            | paf:paDemandPaymentNoticeResponse | RemoveParent                                                                                                                                    | TRES_PDPN_06 |
            | paf:paDemandPaymentNoticeResponse | Empty                                                                                                                                           | TRES_PDPN_07 |
            | outcome                           | None                                                                                                                                            | TRES_PDPN_08 |
            | outcome                           | Empty                                                                                                                                           | TRES_PDPN_09 |
            | outcome                           | PP                                                                                                                                              | TRES_PDPN_10 |
            | qrCode                            | None                                                                                                                                            | TRES_PDPN_12 |
            | qrCode                            | RemoveParent                                                                                                                                    | TRES_PDPN_13 |
            | qrCode                            | Empty                                                                                                                                           | TRES_PDPN_14 |
            | fiscalCode                        | None                                                                                                                                            | TRES_PDPN_15 |
            | fiscalCode                        | 1234567890                                                                                                                                      | TRES_PDPN_16 |
            | fiscalCode                        | 123456789012                                                                                                                                    | TRES_PDPN_17 |
            | fiscalCode                        | 1234567890a                                                                                                                                     | TRES_PDPN_18 |
            | fiscalCode                        | 1234567890à                                                                                                                                     | TRES_PDPN_18 |
            | noticeNumber                      | None                                                                                                                                            | TRES_PDPN_19 |
            | noticeNumber                      | 12345678901234567                                                                                                                               | TRES_PDPN_20 |
            | noticeNumber                      | 1234567890123456789                                                                                                                             | TRES_PDPN_21 |
            | noticeNumber                      | 12345678901234567a                                                                                                                              | TRES_PDPN_22 |
            | noticeNumber                      | 12345678901234567à                                                                                                                              | TRES_PDPN_22 |
            | paymentList                       | None                                                                                                                                            | TRES_PDPN_23 |
            | paymentList                       | RemoveParent                                                                                                                                    | TRES_PDPN_24 |
            | paymentList                       | Empty                                                                                                                                           | TRES_PDPN_25 |
            | paymentOptionDescription          | None                                                                                                                                            | TRES_PDPN_27 |
            | paymentOptionDescription          | Empty                                                                                                                                           | TRES_PDPN_28 |
            | amount                            | None                                                                                                                                            | TRES_PDPN_30 |
            | amount                            | Empty                                                                                                                                           | TRES_PDPN_31 |
            | amount                            | 11,34                                                                                                                                           | TRES_PDPN_32 |
            | amount                            | 11.342                                                                                                                                          | TRES_PDPN_33 |
            | amount                            | 1219087657.34                                                                                                                                   | TRES_PDPN_34 |
            | amount                            | ciao                                                                                                                                            | TRES_PDPN_35 |
            | options                           | None                                                                                                                                            | TRES_PDPN_36 |
            | options                           | Empty                                                                                                                                           | TRES_PDPN_37 |
            | options                           | KK                                                                                                                                              | TRES_PDPN_38 |
            | dueDate                           | Empty                                                                                                                                           | TRES_PDPN_40 |
            | dueDate                           | 20220613                                                                                                                                        | TRES_PDPN_41 |
            | dueDate                           | 12-09-22                                                                                                                                        | TRES_PDPN_41 |
            | dueDate                           | 12-08-2022T12:00:678                                                                                                                            | TRES_PDPN_41 |
            | detailDescription                 | Empty                                                                                                                                           | TRES_PDPN_43 |
            | detailDescription                 | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | TRES_PDPN_44 |
            | allCCP                            | None                                                                                                                                            | TRES_PDPN_45 |
            | allCCP                            | Empty                                                                                                                                           | TRES_PDPN_46 |
            | allCCP                            | 3                                                                                                                                               | TRES_PDPN_47 |
            | paymentDescription                | None                                                                                                                                            | TRES_PDPN_48 |
            | paymentDescription                | Empty                                                                                                                                           | TRES_PDPN_49 |
            | paymentDescription                | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | TRES_PDPN_50 |
            | fiscalCodePA                      | None                                                                                                                                            | TRES_PDPN_51 |
            | fiscalCodePA                      | Empty                                                                                                                                           | TRES_PDPN_52 |
            | fiscalCodePA                      | 123456789012                                                                                                                                    | TRES_PDPN_53 |
            | fiscalCodePA                      | 12345jh%lk9                                                                                                                                     | TRES_PDPN_54 |
            | companyName                       | None                                                                                                                                            | TRES_PDPN_55 |
            | companyName                       | Empty                                                                                                                                           | TRES_PDPN_56 |
            | companyName                       | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | TRES_PDPN_57 |
            | officeName                        | Empty                                                                                                                                           | TRES_PDPN_59 |
            | officeName                        | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | TRES_PDPN_60 |

    # TRES_PDPN_11
    @ALL @PRIMITIVE @NM4 
    Scenario: TRES_PDPN_11
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice scenario executed successfully
        And outcome with KO in paDemandPaymentNotice
        And qrCode with None in paDemandPaymentNotice
        And paymentList with None in paDemandPaymentNotice
        And officeName with None in paDemandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response

    # TRES_PDPN_26
    @ALL @PRIMITIVE @NM4 
    Scenario: TRES_PDPN_26
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice with 2 paymentList scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response

    # TRES_PDPN_29
    @ALL @PRIMITIVE @NM4 
    Scenario: TRES_PDPN_29
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice with 2 paymentOptionDescription scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response

    # TRES_PDPN_61

    Scenario: TRES_PDPN_61 (part 1)
        Given updates through the query update_id_intermediario_psp of the table INTERMEDIARI_PSP the parameter FAULT_BEAN_ESTESO with Y under macro Mod4 on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        And the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice KO scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of demandPaymentNotice response
        And check originalFaultCode field exists in demandPaymentNotice response
        And check originalFaultString field exists in demandPaymentNotice response
        And check originalDescription field exists in demandPaymentNotice response
    @ALL @PRIMITIVE @NM4 
    Scenario: TRES_PDPN_61 (part 2)
        Given the TRES_PDPN_61 (part 1) scenario executed successfully
        And updates through the query update_id_intermediario_psp of the table INTERMEDIARI_PSP the parameter FAULT_BEAN_ESTESO with N under macro Mod4 on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of demandPaymentNotice response
        And check originalFaultCode field not exists in demandPaymentNotice response
        And check originalFaultString field not exists in demandPaymentNotice response
        And check originalDescription field not exists in demandPaymentNotice response