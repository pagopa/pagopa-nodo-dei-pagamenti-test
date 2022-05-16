Feature: check syntax OK for nodoCarrelloMultibeneficiarioRPT


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

      Scenario Outline: Check OK response on missing optional fields multiBeneficiario - SIN_nodoInviaCarrelloMb_01
      Given <elem> with <value> in nodoInviaCarrelloRPT
      When psp sends soap nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaCarrelloRPT response
      Examples:
        | elem              | value | soapUI test                |
        | multiBeneficiario | None  | SIN_nodoInviaCarrelloMb_01 |