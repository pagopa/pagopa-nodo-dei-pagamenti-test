Feature: check syntax KO for nodoCarrelloMultibeneficiarioRPT


 Background:
        Given systems up
        Given initial XML nodoInviaCarrelloRPT
            """
                <xsd:complexType name="nodoInviaCarrelloRPT">
                    <xsd:sequence>
                    <xsd:element name="password" type="ppt:stPassword" />
                    <xsd:element name="identificativoPSP" type="ppt:stText35" />
                    <xsd:element name="identificativoIntermediarioPSP" type="ppt:stText35" />
                    <xsd:element name="identificativoCanale" type="ppt:stText35" />
                    <xsd:element name="listaRPT" type="ppt:tipoListaRPT" />
                    <xsd:element name="requireLightPayment" type="ppt:stZeroUno" minOccurs="0" />
                    <xsd:element name="codiceConvenzione" type="ppt:stConvenzione" minOccurs="0" />
                    <xsd:element name="multiBeneficiario" type="xsd:boolean" minOccurs="0" />
                    </xsd:sequence>
                </xsd:complexType>
      """"

# element value check
  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
    Given <elem> with <value> in nodoInviaCarrelloRPT
    When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check outcome is KO of nodoInviaCarrelloRPT response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response
    Examples:
            | tag                               | tag_value                                                      | soapUI test                             |
            | multiBeneficiario                 | Empty                                                          | SIN_PASIN_nodoInviaCarrelloMb_01RPTR_02 |
            | multiBeneficiario                 | ABCDEFG                                                        | SIN_PASIN_nodoInviaCarrelloMb_01RPTR_03 |
            | multiBeneficiario                 | OK                                                             | SIN_PASIN_nodoInviaCarrelloMb_01RPTR_03 |
            | multiBeneficiario                 | 3                                                              | SIN_PASIN_nodoInviaCarrelloMb_01RPTR_03 |
            | multiBeneficiario                 | lunghezza != 2n                                                | SIN_PASIN_nodoInviaCarrelloMb_01RPTR_03 |
            | identificativoCarrello            | None                                                           | SIN_PASIN_nodoInviaCarrelloMb_01RPTR_04 |
            | identificativoCarrello            | Empty                                                          | SIN_PASIN_nodoInviaCarrelloMb_01RPTR_05 |
            | multiBeneficiario                 | 123456789BBCDEFGHILMNOPQRSTVZ3423123                           | SIN_PASIN_nodoInviaCarrelloMb_01RPTR_06 |
