Feature:  process checks for verifyPaymentNotice 1358

  Background:
    Given systems up


    # paaVerificaRPT OK
    Scenario: Execute paaVerificaRPT OK
        Given initial XML paaVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/"   xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
               <ws:paaVerificaRPTRisposta>
                  <paaVerificaRPTRisposta>
                     <esito>OK</esito>
                     <datiPagamentoPA>
                        <importoSingoloVersamento>1.00</importoSingoloVersamento>
                        <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
                        <bicAccredito>BSCTCH22</bicAccredito>
                        <enteBeneficiario>
                           <pag:identificativoUnivocoBeneficiario>
                              <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
                              <pag:codiceIdentificativoUnivoco>#id_station_old#</pag:codiceIdentificativoUnivoco>
                           </pag:identificativoUnivocoBeneficiario>
                           <pag:denominazioneBeneficiario>f6</pag:denominazioneBeneficiario>
                           <pag:codiceUnitOperBeneficiario>r6</pag:codiceUnitOperBeneficiario>
                           <pag:denomUnitOperBeneficiario>yr</pag:denomUnitOperBeneficiario>
                           <pag:indirizzoBeneficiario>\"paaVerificaRPT\"</pag:indirizzoBeneficiario>
                           <pag:civicoBeneficiario>ut</pag:civicoBeneficiario>
                           <pag:capBeneficiario>jyr</pag:capBeneficiario>
                           <pag:localitaBeneficiario>yj</pag:localitaBeneficiario>
                           <pag:provinciaBeneficiario>h8</pag:provinciaBeneficiario>
                           <pag:nazioneBeneficiario>IT</pag:nazioneBeneficiario>
                        </enteBeneficiario>
                        <credenzialiPagatore>of8</credenzialiPagatore>
                        <causaleVersamento>paaVerificaRPT</causaleVersamento>
                     </datiPagamentoPA>
                  </paaVerificaRPTRisposta>
               </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT


    # verifyPaymentNotice OK - EC old [PRO_VPNR_01]
    @runnable
    Scenario: Execute verifyPaymentNotice request OLD OK
        Given the Execute paaVerificaRPT OK scenario executed successfully
        And initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
               <soapenv:Header/>
               <soapenv:Body>
                  <nod:verifyPaymentNoticeReq>
                     <idPSP>#psp#</idPSP>
                     <idBrokerPSP>#psp#</idBrokerPSP>
                     <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
                     <password>pwdpwdpwd</password>
                     <qrCode>
                        <fiscalCode>#creditor_institution_code_old#</fiscalCode>
                        <noticeNumber>#notice_number_old#</noticeNumber>
                     </qrCode>
                  </nod:verifyPaymentNoticeReq>
               </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC old version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        And check paymentDescription is paaVerificaRPT of verifyPaymentNotice response


    # verifyPaymentNotice OK - EC new [PRO_VPNR_02 - PRO_VPNR_09]
    @runnable
    Scenario: Execute verifyPaymentNotice request NEW OK
        Given initial XML paVerifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
               <paf:paVerifyPaymentNoticeRes>
                  <outcome>OK</outcome>
                  <paymentList>
                     <paymentOptionDescription>
                        <amount>70.00</amount>
                        <options>EQ</options>
                        <dueDate>2021-07-31</dueDate>
                        <detailDescription>pagamentoTest</detailDescription>
                        <allCCP>false</allCCP>
                     </paymentOptionDescription>
                  </paymentList>
                  <paymentDescription>paVerifyPaymentNotice</paymentDescription>
                  <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                  <companyName>companyName</companyName>
                  <officeName>officeName</officeName>
               </paf:paVerifyPaymentNoticeRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        And initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
               <soapenv:Header/>
               <soapenv:Body>
                  <nod:verifyPaymentNoticeReq>
                     <idPSP>#psp#</idPSP>
                     <idBrokerPSP>#psp#</idBrokerPSP>
                     <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
                     <password>pwdpwdpwd</password>
                     <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>#notice_number#</noticeNumber>
                     </qrCode>
                  </nod:verifyPaymentNoticeReq>
               </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC new version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        And check paymentDescription is paVerifyPaymentNotice of verifyPaymentNotice response
        And check allCCP field not exists in verifyPaymentNotice response


    # nodoVerificaRPT OK - EC old [PRO_VPNR_03]
    @runnable
    Scenario: Execute nodoVerificaRPT request OLD OK
        Given the Execute paaVerificaRPT OK scenario executed successfully
        And initial XML nodoVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
               <soapenv:Header/>
               <soapenv:Body>
                  <ws:nodoVerificaRPT>
                     <identificativoPSP>#psp#</identificativoPSP>
                     <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                     <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
                     <password>pwdpwdpwd</password>
                     <codiceContestoPagamento>${#TestCase#ccp}</codiceContestoPagamento>
                     <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                     <codiceIdRPT>
                        <qrc:QrCode>
                           <qrc:CF>#creditor_institution_code_old#</qrc:CF>
                           <qrc:CodStazPA>02</qrc:CodStazPA>
                           <qrc:AuxDigit>0</qrc:AuxDigit>
                           <qrc:CodIUV>188321399210254</qrc:CodIUV>
                        </qrc:QrCode>
                     </codiceIdRPT>
                  </ws:nodoVerificaRPT>
               </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC old version
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoVerificaRPT response
        And check causaleVersamento is paaVerificaRPT of nodoVerificaRPT response


    # verifyPaymentNotice KO - EC old [PRO_VPNR_05]
    @runnable
    Scenario: Execute verifyPaymentNotice request OLD KO
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
                           <id>#creditor_institution_code_old#</id>
                        </fault>            
                        <esito>KO</esito>
                  </paaVerificaRPTRisposta>
               </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        And initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
               <soapenv:Header/>
               <soapenv:Body>
                  <nod:verifyPaymentNoticeReq>
                     <idPSP>#psp#</idPSP>
                     <idBrokerPSP>#psp#</idBrokerPSP>
                     <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
                     <password>pwdpwdpwd</password>
                     <qrCode>
                        <fiscalCode>#creditor_institution_code_old#</fiscalCode>
                        <noticeNumber>#notice_number_old#</noticeNumber>
                     </qrCode>
                  </nod:verifyPaymentNoticeReq>
               </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC old version
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of verifyPaymentNotice response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verifyPaymentNotice response
