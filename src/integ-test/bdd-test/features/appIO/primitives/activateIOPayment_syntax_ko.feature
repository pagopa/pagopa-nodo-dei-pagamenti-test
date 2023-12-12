Feature: Syntax checks for activateIOPaymentReq - KO

    Background:
        Given systems up
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activateIOPaymentReq>
            <idPSP>#psp_AGID#</idPSP>
            <idBrokerPSP>#broker_AGID#</idBrokerPSP>
            <idChannel>#canale_AGID#</idChannel>
            <password>pwdpwdpwd</password>
            <!--Optional:-->
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
            <!--Optional:-->
            <expirationTime>12345</expirationTime>
            <amount>10.00</amount>
            <!--Optional:-->
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <paymentNote>test</paymentNote>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>civic</civicNumber>
            <!--Optional:-->
            <postalCode>code</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>test.prova@gmail.com</e-mail>
            </payer>
            </nod:activateIOPaymentReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    @runnable @PG34
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given <elem> with <value> in activateIOPayment
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is KO of activateIOPayment response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activateIOPayment response
        Examples:
            | elem                       | value | soapUI test  |
            | entityUniqueIdentifierType | None  | SIN_AIOPR_02 |
            | entityUniqueIdentifierType | Empty | SIN_AIOPR_03 |
            | idempotencyKey             | Empty | SIN_AIOPR_04 |
            | amount                     | None  | SIN_AIOPR_24 |
            | amount                     | Empty | SIN_AIOPR_26 |
            | fiscalCode                 | Empty | SIN_AIOPR_27 |
            | noticeNumber               | Empty | SIN_AIOPR_32 |

    @runnable
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        Given <attribute> set <value> for <elem> in activateIOPayment
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is KO of activateIOPayment response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activateIOPayment response
        Examples:
            | elem             | attribute     | value                                     | soapUI test  |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_AIOPR_01 |

    @runnable
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given <elem> with <value> in activateIOPayment
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is KO of activateIOPayment response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activateIOPayment response
        Examples:
            | elem                        | value                                                                                                                                                                                                                                                             | soapUI test  |
            | idPSP                       | None                                                                                                                                                                                                                                                              | SIN_AIOPR_05 |
            | idPSP                       | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_06 |
            | idPSP                       | rwEtgqWfYwFQPbViQGnNezKnsNtPOAHLgllk                                                                                                                                                                                                                              | SIN_AIOPR_07 |
            | idBrokerPSP                 | None                                                                                                                                                                                                                                                              | SIN_AIOPR_08 |
            | idBrokerPSP                 | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_09 |
            | idBrokerPSP                 | rwEtgqWfYwFQPbViQGnNezKnsNtPOAHLgllk                                                                                                                                                                                                                              | SIN_AIOPR_10 |
            | idChannel                   | None                                                                                                                                                                                                                                                              | SIN_AIOPR_11 |
            | idChannel                   | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_12 |
            | idChannel                   | rwEtgqWfYwFQPbViQGnNezKnsNtPOAHLgllk                                                                                                                                                                                                                              | SIN_AIOPR_13 |
            | password                    | None                                                                                                                                                                                                                                                              | SIN_AIOPR_14 |
            | password                    | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_15 |
            | password                    | WTeAoAY                                                                                                                                                                                                                                                           | SIN_AIOPR_16 |
            | password                    | GHeMXkNiRWqgvQCB                                                                                                                                                                                                                                                  | SIN_AIOPR_17 |
            | idempotencyKey              | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_19 |
            | idempotencyKey              | 70000000001.1244565744                                                                                                                                                                                                                                            | SIN_AIOPR_20 |
            | idempotencyKey              | 70000000001_%244565744                                                                                                                                                                                                                                            | SIN_AIOPR_20 |
            | idempotencyKey              | 70000000001-1244565744                                                                                                                                                                                                                                            | SIN_AIOPR_20 |
            | idempotencyKey              | 1244565768_70000000001                                                                                                                                                                                                                                            | SIN_AIOPR_20 |
            | idempotencyKey              | 1244565744                                                                                                                                                                                                                                                        | SIN_AIOPR_20 |
            | idempotencyKey              | 700000000011244565744                                                                                                                                                                                                                                             | SIN_AIOPR_20 |
            | idempotencyKey              | 70000000001_12445657684                                                                                                                                                                                                                                           | SIN_AIOPR_21 |
            | idempotencyKey              | 70000000001_124456576                                                                                                                                                                                                                                             | SIN_AIOPR_22 |
            | idempotencyKey              | 700000hj123_1244565767                                                                                                                                                                                                                                            | SIN_AIOPR_23 |
            | qrCode                      | RemoveParent                                                                                                                                                                                                                                                      | SIN_AIOPR_25 |
            | fiscalCode                  | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_28 |
            | fiscalCode                  | qvQoUVvmru                                                                                                                                                                                                                                                        | SIN_AIOPR_29 |
            | fiscalCode                  | oACMPdRkhfgo                                                                                                                                                                                                                                                      | SIN_AIOPR_30 |
            | fiscalCode                  | oACMPd%khfgo                                                                                                                                                                                                                                                      | SIN_AIOPR_31 |
            | noticeNumber                | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_33 |
            | noticeNumber                | 43138814989806638                                                                                                                                                                                                                                                 | SIN_AIOPR_34 |
            | noticeNumber                | 7289343950087913278                                                                                                                                                                                                                                               | SIN_AIOPR_34 |
            | noticeNumber                | OKHaHUtWnlqWxKKTcP                                                                                                                                                                                                                                                | SIN_AIOPR_35 |
            | noticeNumber                | 72893439%008791327                                                                                                                                                                                                                                                | SIN_AIOPR_35 |
            | expirationTime              | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_37 |
            | expirationTime              | 2021-12-12T12:12:12                                                                                                                                                                                                                                               | SIN_AIOPR_38 |
            | expirationTime              | 48:12:12                                                                                                                                                                                                                                                          | SIN_AIOPR_38 |
            | expirationTime              | 12:12                                                                                                                                                                                                                                                             | SIN_AIOPR_38 |
            | expirationTime              | 1800001                                                                                                                                                                                                                                                           | SIN_AIOPR_39 |
            | amount                      | None                                                                                                                                                                                                                                                              | SIN_AIOPR_40 |
            | amount                      | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_41 |
            | amount                      | 21,09                                                                                                                                                                                                                                                             | SIN_AIOPR_42 |
            | amount                      | 21.1                                                                                                                                                                                                                                                              | SIN_AIOPR_43 |
            | amount                      | 21.123                                                                                                                                                                                                                                                            | SIN_AIOPR_43 |
            | amount                      | 9993773361698.00                                                                                                                                                                                                                                                  | SIN_AIOPR_44 |
            | dueDate                     | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_46 |
            | dueDate                     | 12-28-2021                                                                                                                                                                                                                                                        | SIN_AIOPR_47 |
            | dueDate                     | 28-12-21                                                                                                                                                                                                                                                          | SIN_AIOPR_47 |
            | dueDate                     | 2021-12-21T12:12:12                                                                                                                                                                                                                                               | SIN_AIOPR_47 |
            | paymentNote                 | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_49 |
            | paymentNote                 | IUpHmOvVLnRzJWcbqsUUarmTKZMtXliswsLrgzktqwLawObaMbuoDZBjqcxDaYOofvZrYaWgzsOlUomloNVSRqAPiPGEnLdFmMDhXAewEtKYdzxjOKBjqbDJsRcKXuCIUVvwsfDLqHUZTqJmmGAShyfzxFvQJYnvFllqTPvuoyGXOuLYxqhMUfNNtezgdjlSFrtPbtcBBgAvZblWkwf                                               | SIN_AIOPR_50 |
            | payer                       | RemoveParent                                                                                                                                                                                                                                                      | SIN_AIOPR_52 |
            | payer                       | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_53 |
            | uniqueIdentifier            | None                                                                                                                                                                                                                                                              | SIN_AIOPR_54 |
            | uniqueIdentifier            | RemoveParent                                                                                                                                                                                                                                                      | SIN_AIOPR_55 |
            | uniqueIdentifier            | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_56 |
            | entityUniqueIdentifierType  | None                                                                                                                                                                                                                                                              | SIN_AIOPR_57 |
            | entityUniqueIdentifierType  | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_58 |
            | entityUniqueIdentifierType  | GG                                                                                                                                                                                                                                                                | SIN_AIOPR_59 |
            | entityUniqueIdentifierType  | A                                                                                                                                                                                                                                                                 | SIN_AIOPR_60 |
            | entityUniqueIdentifierValue | None                                                                                                                                                                                                                                                              | SIN_AIOPR_61 |
            | entityUniqueIdentifierValue | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_62 |
            | entityUniqueIdentifierValue | ioyajeDCNnVqnfIFr                                                                                                                                                                                                                                                 | SIN_AIOPR_63 |
            | fullName                    | None                                                                                                                                                                                                                                                              | SIN_AIOPR_64 |
            | fullName                    | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_65 |
            | fullName                    | TvopROKsJYPoIZmZKLvhfHKccqzAUWacBPcvJrtYPYZRLcpWVdkXTZHkulnYKtIhuqPufFE                                                                                                                                                                                           | SIN_AIOPR_66 |
            | streetName                  | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_68 |
            | streetName                  | TvopROKsJYPoIZmZKLvhfHKccqzAUWacBPcvJrtYPYZRLcpWVdkXTZHkulnYKtIhuqPufFE                                                                                                                                                                                           | SIN_AIOPR_69 |
            | civicNumber                 | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_71 |
            | civicNumber                 | bwfqFVndjpRxrxTgW                                                                                                                                                                                                                                                 | SIN_AIOPR_72 |
            | postalCode                  | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_74 |
            | postalCode                  | bwfqFVndjpRxrxTgW                                                                                                                                                                                                                                                 | SIN_AIOPR_75 |
            | city                        | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_77 |
            | city                        | CJMwIAbjHVshaJhFZozOrGOOCqpJoUDxuHog                                                                                                                                                                                                                              | SIN_AIOPR_78 |
            | stateProvinceRegion         | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_80 |
            | stateProvinceRegion         | CJMwIAbjHVshaJhFZozOrGOOCqpJoUDxuHog                                                                                                                                                                                                                              | SIN_AIOPR_81 |
            | country                     | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_83 |
            | country                     | abc                                                                                                                                                                                                                                                               | SIN_AIOPR_84 |
            | country                     | it                                                                                                                                                                                                                                                                | SIN_AIOPR_85 |
            | e-mail                      | Empty                                                                                                                                                                                                                                                             | SIN_AIOPR_87 |
            | e-mail                      | CJMwIAbjHVshaJhFZozOrGOOCqpJoUDxuHog                                                                                                                                                                                                                              | SIN_AIOPR_88 |
            | e-mail                      | mBpgcdfPdDHOifLVlMinLWAypHOCNkRbZacRjwGCREKlmcJyPxsOnlWAcbAumNFAxPBACyettBmpZgKriIvZwtKtpqxQsyjOaOCawysMdZqpIHaQszyFrerGAKiVSpqXUXBfvpzGKSiTeiHJjhOxryquOwsVBCtlOTEasGZVZvgxmjPVBzZeUHGRhdeWKVmuwRSOQKfjGvGLnYIbgvWBlxEZuIVvNoLECwZukosmoLulzvorCTgXvSBtMreMVYvEm | SIN_AIOPR_89 |
