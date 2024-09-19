Feature: TEST BUG FIX FOR PAG-112


    Background:
        Given systems up



    @ALL @PAG_112 @PAG_112_1 @after
    Scenario: NM4 flow KO, FLOW con PA New vp1: nodoChiediCatalogoServiziV2 check validation XSD
        Given from body with datatable horizontal nodoChiediCatalogoServiziV2_noOptional initial XML nodoChiediCatalogoServiziV2
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   |
            | #psp#             | #psp#                          | #canale_ATTIVATO_PRESSO_PSP# | #password# |
        When PSP sends SOAP nodoChiediCatalogoServiziV2 to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServiziV2 response
        And check outcome is OK of nodoChiediCatalogoServiziV2 response
        And save nodoChiediCatalogoServiziV2 response in nodoChiediCatalogoServiziV2
        And validating xml response nodoChiediCatalogoServiziV2Response by xsd CatalogoServizi_2_0_0