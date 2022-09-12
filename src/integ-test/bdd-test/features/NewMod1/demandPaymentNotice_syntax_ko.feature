Feature: syntax checks for demandPaymentNotice - KO

    Background: Given systems up

    Scenario: demandPaymentNotice
        Given initial demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <idSoggettoServizio>00001</idSoggettoServizio>
            <datiSpecificiServizio>ciao</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: demandPaymentNotice with two occurrences of idSoggettoServizio
        Given initial demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <idSoggettoServizio>00001</idSoggettoServizio>
            <idSoggettoServizio>00001</idSoggettoServizio>
            <datiSpecificiServizio>ciao</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: demandPaymentNotice with two occurrences of datiSpecificiServizio
        Given initial demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <idSoggettoServizio>00001</idSoggettoServizio>
            <datiSpecificiServizio>ciao</datiSpecificiServizio>
            <datiSpecificiServizio>ciao</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    # attribute value check
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        Given the demandPaymentNotice scenario executed successfully
        And <attribute> set <value> for <elem> in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of demandPaymentNotice response
        Examples:
            | elem             | attribute     | value                                     | soapUI test |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_DPNR_01 |

    # element value check
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given the demandPaymentNotice scenario executed successfully
        And <elem> with <value> in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of demandPaymentNotice response
        Examples:
            | elem                       | value                                | soapUI test   |
            | soapenv:Body               | None                                 | SIN_DPNR_02   |
            | soapenv:Body               | Empty                                | SIN_DPNR_03   |
            | ns3:demandPaymentNoticeReq | Empty                                | SIN_DPNR_04   |
            | idPSP                      | None                                 | SIN_DPNR_05   |
            | idPSP                      | Empty                                | SIN_DPNR_06   |
            | idPSP                      | 123456789012345678901234567890123456 | SIN_DPNR_07   |
            | idBrokerPSP                | None                                 | SIN_DPNR_08   |
            | idBrokerPSP                | Empty                                | SIN_DPNR_09   |
            | idBrokerPSP                | 123456789012345678901234567890123456 | SIN_DPNR_10   |
            | idChannel                  | None                                 | SIN_DPNR_11   |
            | idChannel                  | Empty                                | SIN_DPNR_12   |
            | idChannel                  | 123456789012345678901234567890123456 | SIN_DPNR_13   |
            | password                   | None                                 | SIN_DPNR_14   |
            | password                   | Empty                                | SIN_DPNR_15   |
            | password                   | 1234567                              | SIN_DPNR_16   |
            | password                   | 123456789012345678901234567890123456 | SIN_DPNR_17   |
            | idSoggettoServizio         | None                                 | SIN_DPNR_18   |
            | idSoggettoServizio         | Empty                                | SIN_DPNR_19   |
            | idSoggettoServizio         | 123456                               | SIN_DPNR_20   |
            | idSoggettoServizio         | 1234                                 | SIN_DPNR_20.1 |
            | datiSpecificiServizio      | None                                 | SIN_DPNR_22   |
            | datiSpecificiServizio      | Empty                                | SIN_DPNR_23   |
            | datiSpecificiServizio      | cia                                  | SIN_DPNR_24   |
            | datiSpecificiServizio      | cia$                                 | SIN_DPNR_25   |

    # two occurrences of idSoggettoServizio - SIN_DPNR_21.1
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid demandPaymentNotice
        Given the demandPaymentNotice with two occurrences of idSoggettoServizio scenario executed successfully
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of demandPaymentNotice response

    # two occurrences of datiSpecificiServizio - SIN_DPNR_26
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid demandPaymentNotice
        Given the demandPaymentNotice with two occurrences of datiSpecificiServizio scenario executed successfully
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of demandPaymentNotice response