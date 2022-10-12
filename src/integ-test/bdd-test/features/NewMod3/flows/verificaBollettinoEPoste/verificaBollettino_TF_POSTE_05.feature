Feature: flow checks for verificaBollettino - EC old [TF_POSTE_05]

    Background:
        Given systems up
        And EC old version

    # verificaBollettinoReq phase
    Scenario: Execute verificaBollettino request
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And generate 1 cart with PA #creditor_institution_code_old# and notice number $1noticeNumber
        And nodo-dei-pagamenti has config parameter verificabollettino.validity.minutes set to 1
        # #And initial XML paaVerificaRPT
        #     """
        #     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/"   xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        #     <soapenv:Header/>
        #     <soapenv:Body>
        #     <ws:paaVerificaRPTRisposta>
        #     <paaVerificaRPTRisposta>
        #     <esito>OK</esito>
        #     <datiPagamentoPA>
        #     <importoSingoloVersamento>1.00</importoSingoloVersamento>
        #     <ibanAccredito>IT45R0760103200#ccPoste#</ibanAccredito>
        #     <bicAccredito>BSCTCH22</bicAccredito>
        #     <enteBeneficiario>
        #     <pag:identificativoUnivocoBeneficiario>
        #     <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
        #     <pag:codiceIdentificativoUnivoco>#id_station_old#</pag:codiceIdentificativoUnivoco>
        #     </pag:identificativoUnivocoBeneficiario>
        #     <pag:denominazioneBeneficiario>f6</pag:denominazioneBeneficiario>
        #     <pag:codiceUnitOperBeneficiario>r6</pag:codiceUnitOperBeneficiario>
        #     <pag:denomUnitOperBeneficiario>yr</pag:denomUnitOperBeneficiario>
        #     <pag:indirizzoBeneficiario>\"paaVerificaRPT\"</pag:indirizzoBeneficiario>
        #     <pag:civicoBeneficiario>ut</pag:civicoBeneficiario>
        #     <pag:capBeneficiario>jyr</pag:capBeneficiario>
        #     <pag:localitaBeneficiario>yj</pag:localitaBeneficiario>
        #     <pag:provinciaBeneficiario>h8</pag:provinciaBeneficiario>
        #     <pag:nazioneBeneficiario>IT</pag:nazioneBeneficiario>
        #     </enteBeneficiario>
        #     <credenzialiPagatore>of8</credenzialiPagatore>
        #     <causaleVersamento>paaVerificaRPT</causaleVersamento>
        #     </datiPagamentoPA>
        #     </paaVerificaRPTRisposta>
        #     </ws:paaVerificaRPTRisposta>
        #     </soapenv:Body>
        #     </soapenv:Envelope>
        #     """
        # And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
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
                    <noticeNumber>$1noticeNumber</noticeNumber>
                </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        And PSP waits 62 seconds for expiration
        And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3
        

    # activatePaymentNoticeReq phase
    Scenario: Execute activatePaymentNotice request
        Given the Execute verificaBollettino request scenario executed successfully
        # And initial XML paaAttivaRPT
        #     """
        #     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        #     <soapenv:Header/>
        #     <soapenv:Body>
        #     <ws:paaAttivaRPTRisposta>
        #         <paaAttivaRPTRisposta>
        #             <esito>OK</esito>
        #             <datiPagamentoPA>
        #                 <importoSingoloVersamento>10.00</importoSingoloVersamento>
        #                 <ibanAccredito>IT45R0760103200#ccPoste#</ibanAccredito>
        #                 <enteBeneficiario>
        #                     <pag:identificativoUnivocoBeneficiario>
        #                     <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
        #                     <pag:codiceIdentificativoUnivoco>#creditor_institution_code_old#</pag:codiceIdentificativoUnivoco>
        #                     </pag:identificativoUnivocoBeneficiario>
        #                     <pag:denominazioneBeneficiario>Pa Gabri</pag:denominazioneBeneficiario>
        #                 </enteBeneficiario>
        #                 <credenzialiPagatore>tizio caio</credenzialiPagatore>
        #                 <causaleVersamento>12345$1iuv</causaleVersamento>
        #             </datiPagamentoPA>
        #         </paaAttivaRPTRisposta>
        #     </ws:paaAttivaRPTRisposta>
        #     </soapenv:Body>
        #     </soapenv:Envelope>
        #     """
        # And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activatePaymentNoticeReq>
                    <idPSP>#pspPoste#</idPSP>
                    <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
                    <idChannel>#channelPoste#</idChannel>
                    <password>pwdpwdpwd</password>
                    <qrCode>
                        <fiscalCode>#creditor_institution_code_old#</fiscalCode>
                        <noticeNumber>$verificaBollettino.noticeNumber</noticeNumber>
                    </qrCode>
                    <amount>10.00</amount>
                </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_IBAN_ACCREDITO of activatePaymentNotice response
        And check faultString is Iban accredito non disponibile of activatePaymentNotice response
        And check description is Verifica non completata of activatePaymentNotice response
        And restore initial configurations
        
    