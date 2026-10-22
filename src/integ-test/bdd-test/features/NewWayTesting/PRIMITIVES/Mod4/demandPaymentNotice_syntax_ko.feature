Feature: syntax checks for demandPaymentNotice - KO 926

    Background:
        Given systems up

    @ALL @PRIMITIVE @NM4 @NM4SINDPNRKO @NM4SINDPNRKO_1
    # attribute value check
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001              |
        And <attribute> set <value> for <elem> in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of demandPaymentNotice response
        Examples:
            | elem             | attribute     | value                                     | soapUI test |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_DPNR_01 |


    @ALL @PRIMITIVE @NM4 @NM4SINDPNRKO @NM4SINDPNRKO_2
    # element value check
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001              |
        And <elem> with <value> in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of demandPaymentNotice response
        Examples:
            | elem                           | value                                | soapUI test   |
            | soapenv:Body                   | None                                 | SIN_DPNR_02   |
            | soapenv:Body                   | Empty                                | SIN_DPNR_03   |
            | nod:demandPaymentNoticeRequest | Empty                                | SIN_DPNR_04   |
            | idPSP                          | None                                 | SIN_DPNR_05   |
            | idPSP                          | Empty                                | SIN_DPNR_06   |
            | idPSP                          | 123456789012345678901234567890123456 | SIN_DPNR_07   |
            | idBrokerPSP                    | None                                 | SIN_DPNR_08   |
            | idBrokerPSP                    | Empty                                | SIN_DPNR_09   |
            | idBrokerPSP                    | 123456789012345678901234567890123456 | SIN_DPNR_10   |
            | idChannel                      | None                                 | SIN_DPNR_11   |
            | idChannel                      | Empty                                | SIN_DPNR_12   |
            | idChannel                      | 123456789012345678901234567890123456 | SIN_DPNR_13   |
            | password                       | None                                 | SIN_DPNR_14   |
            | password                       | Empty                                | SIN_DPNR_15   |
            | password                       | 1234567                              | SIN_DPNR_16   |
            | password                       | 123456789012345678901234567890123456 | SIN_DPNR_17   |
            | idSoggettoServizio             | None                                 | SIN_DPNR_18   |
            | idSoggettoServizio             | Empty                                | SIN_DPNR_19   |
            | idSoggettoServizio             | 123456                               | SIN_DPNR_20   |
            | idSoggettoServizio             | 1234                                 | SIN_DPNR_20.1 |
            | datiSpecificiServizio          | None                                 | SIN_DPNR_22   |
            | datiSpecificiServizio          | Empty                                | SIN_DPNR_23   |
            | datiSpecificiServizio          | cia                                  | SIN_DPNR_24   |
            | datiSpecificiServizio          | cia$                                 | SIN_DPNR_25   |


    @ALL @PRIMITIVE @NM4 @NM4SINDPNRKO @NM4SINDPNRKO_3
    # element value check
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001              |
        And <elem> with <value> in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of demandPaymentNotice response
        Examples:
            | elem                  | value         | soapUI test   |
            | idSoggettoServizio    | Occurrences,2 | SIN_DPNR_21.1 |
            | datiSpecificiServizio | Occurrences,2 | SIN_DPNR_26   |
