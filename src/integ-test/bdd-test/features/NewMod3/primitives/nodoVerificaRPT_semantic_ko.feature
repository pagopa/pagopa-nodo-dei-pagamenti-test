Feature: Checks for EC new and nodoVerificaRPT

  Background:
    Given systems up
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
                  <codiceContestoPagamento>120671877019565</codiceContestoPagamento>
                  <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                  <codiceIdRPT>
                    <qrc:QrCode>
                      <qrc:CF>#creditor_institution_code#</qrc:CF>
                      <qrc:AuxDigit>3</qrc:AuxDigit>
                      <qrc:CodIUV>02192051789512983</qrc:CodIUV>
                    </qrc:QrCode>
                  </codiceIdRPT>
              </ws:nodoVerificaRPT>
          </soapenv:Body>
        </soapenv:Envelope>
      """
    And EC new version

  @runnable
  # check PPT_MULTI_BENEFICIARIO error - PRO_VPNR_04
  Scenario: Check PPT_MULTI_BENEFICIARIO error
    When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoVerificaRPT response
    And check faultCode is PPT_MULTI_BENEFICIARIO of nodoVerificaRPT response
