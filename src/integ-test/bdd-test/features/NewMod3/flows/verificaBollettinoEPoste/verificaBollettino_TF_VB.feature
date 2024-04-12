Feature: flow checks for verificaBollettino 1355

    Background:
        Given systems up


    # nodoVerificaRPT phase - EC new [TF_VB_01]
    @runnable
    Scenario: Execute nodoVerificaRPT request PPT_MULTI_BENEFICIARIO
        Given initial XML nodoVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoVerificaRPT>
                    <identificativoPSP>#pspPoste#</identificativoPSP>
                    <identificativoIntermediarioPSP>#brokerPspPoste#</identificativoIntermediarioPSP>
                    <identificativoCanale>#channelPoste#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <codiceContestoPagamento>158471690510472</codiceContestoPagamento>
                    <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
                    <codiceIdRPT>
                        <aim:aim128>
                            <aim:CCPost>#ccPoste#</aim:CCPost>
                            <aim:AuxDigit>3</aim:AuxDigit>
                            <aim:CodIUV>#cod_segr#012051482162400</aim:CodIUV>
                        </aim:aim128>
                    </codiceIdRPT>
                </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_MULTI_BENEFICIARIO of nodoVerificaRPT response
        And check faultString is La chiamata non è compatibile con il nuovo modello PSP. of nodoVerificaRPT response


    # nodoVerificaRPT phase - EC old [TF_VB_02]
    @runnable
    Scenario: Execute nodoVerificaRPT request OK
        Given initial XML nodoVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoVerificaRPT>
                    <identificativoPSP>#pspPoste#</identificativoPSP>
                    <identificativoIntermediarioPSP>#brokerPspPoste#</identificativoIntermediarioPSP>
                    <identificativoCanale>#channelPoste#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <codiceContestoPagamento>186881536419882</codiceContestoPagamento>
                    <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
                    <codiceIdRPT>
                        <aim:aim128>
                            <aim:CCPost>#ccPoste#</aim:CCPost>
                            <aim:CodStazPA>02</aim:CodStazPA>
                            <aim:AuxDigit>0</aim:AuxDigit>
                            <aim:CodIUV>015221006112100</aim:CodIUV>
                        </aim:aim128>
                    </codiceIdRPT>
                </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoVerificaRPT response


    # verificaBollettino phase - EC new [TF_VB_03 - TF_VB_05 - TF_VB_08]
    @runnable
    Scenario: Execute verificaBollettino request
        Given the Execute nodoVerificaRPT request PPT_MULTI_BENEFICIARIO scenario executed successfully
        And initial XML verificaBollettino
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:verificaBollettinoReq>
                    <idPSP>#pspPoste#</idPSP>
                    <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
                    <idChannel>#channelPoste#</idChannel>
                    <password>pwdpwdpwd</password>
                    <ccPost>#ccPoste#</ccPost>
                    <noticeNumber>3#cod_segr#012051482162400</noticeNumber>
                </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        And check allCCP field exists in verificaBollettino response
        And verify 0 record for the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3
        

    # verificaBollettino phase 1 - EC old [TF_VB_06]
    Scenario: Execute verificaBollettino request OLD (Phase 1)
        Given initial XML verificaBollettino
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:verificaBollettinoReq>
                    <idPSP>#pspPoste#</idPSP>
                    <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
                    <idChannel>#channelPoste#</idChannel>
                    <password>pwdpwdpwd</password>
                    <ccPost>#ccPoste#</ccPost>
                    <noticeNumber>#notice_number_old#</noticeNumber>
                </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        And wait 5 seconds for expiration
        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3
        And execution query verifica_bollettino to get value on the table VERIFICA_BOLLETTINO, with the columns ID, CCPOST, UPDATED_TIMESTAMP under macro NewMod3 with db name nodo_online
        And through the query verifica_bollettino retrieve param id at position 0 and save it under the key bollettinoId
        And through the query verifica_bollettino retrieve param ccPost at position 1 and save it under the key ccPost
        And through the query verifica_bollettino retrieve param updTimestamp at position 2 and save it under the key updTimestamp


    # verificaBollettino phase 2 - EC old [TF_VB_06]
    @runnable
    Scenario: Execute verificaBollettino request OLD (Phase 2)
        Given the Execute verificaBollettino request OLD (Phase 1) scenario executed successfully
        When wait 10 seconds for expiration
        And PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        And wait 5 seconds for expiration
        And checks the value $bollettinoId of the record at column ID of the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3
        And checks the value $ccPost of the record at column CCPOST of the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3
        And execution query verifica_bollettino to get value on the table VERIFICA_BOLLETTINO, with the columns UPDATED_TIMESTAMP under macro NewMod3 with db name nodo_online
        And through the query verifica_bollettino retrieve param updTimestamp2 at position 0 and save it under the key updTimestamp2
        And check value updTimestamp2 is greater than value updTimestamp
    

    # verificaBollettino KO - EC old [TF_VB_07]
    @runnable
    Scenario: Execute verificaBollettino request OLD KO
        Given initial XML paaVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/"   xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:paaVerificaRPTRisposta>
                    <paaVerificaRPTRisposta>
                        <fault>
                        <faultCode>PAA_SEMANTICA</faultCode>
                        <faultString>chiamata da rifiutare</faultString>
                        <id>${pa}</id>
                        </fault>            
                        <esito>KO</esito>
                    </paaVerificaRPTRisposta>
                </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        And initial XML verificaBollettino
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:verificaBollettinoReq>
                    <idPSP>#pspPoste#</idPSP>
                    <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
                    <idChannel>#channelPoste#</idChannel>
                    <password>pwdpwdpwd</password>
                    <ccPost>#ccPoste#</ccPost>
                    <noticeNumber>#notice_number_old#</noticeNumber>
                </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is KO of verificaBollettino response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verificaBollettino response
        And wait 5 seconds for expiration
        And verify 0 record for the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3


    # verificaBollettino IBAN - EC old [TF_VB_09]
    @runnable
    Scenario: Execute verificaBollettino request OLD IBAN
        Given initial XML verificaBollettino
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:verificaBollettinoReq>
                    <idPSP>#pspPoste#</idPSP>
                    <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
                    <idChannel>#channelPoste#</idChannel>
                    <password>pwdpwdpwd</password>
                    <ccPost>#ccPoste_noIBAN#</ccPost>
                    <noticeNumber>#notice_number_old#</noticeNumber>
                </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is KO of verificaBollettino response
        And check faultCode is PPT_IBAN_ACCREDITO of verificaBollettino response
        And wait 5 seconds for expiration
        And verify 0 record for the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3


    # verificaBollettino IBAN KO - EC old [TF_VB_10]
    @runnable
    Scenario: Execute verificaBollettino request OLD IBAN KO
        Given initial XML paaVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/"   xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:paaVerificaRPTRisposta>
                    <paaVerificaRPTRisposta>
                        <fault>
                        <faultCode>PAA_SEMANTICA</faultCode>
                        <faultString>chiamata da rifiutare</faultString>
                        <id>${pa}</id>
                        </fault>            
                        <esito>KO</esito>
                    </paaVerificaRPTRisposta>
                </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        And initial XML verificaBollettino
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:verificaBollettinoReq>
                    <idPSP>#pspPoste#</idPSP>
                    <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
                    <idChannel>#channelPoste#</idChannel>
                    <password>pwdpwdpwd</password>
                    <ccPost>#ccPoste_noIBAN#</ccPost>
                    <noticeNumber>#notice_number_old#</noticeNumber>
                </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is KO of verificaBollettino response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verificaBollettino response
        And wait 5 seconds for expiration
        And verify 0 record for the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3

