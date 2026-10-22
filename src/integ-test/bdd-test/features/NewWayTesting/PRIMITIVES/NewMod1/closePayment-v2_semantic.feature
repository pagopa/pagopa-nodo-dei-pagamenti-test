Feature: semantic checks for closePaymentV2 962

    Background:
        Given systems up


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SEM @NMU_CLOSE_SEM_1
    # paymentToken unknown [SEM_CP_01]
    Scenario: Check unknown paymentToken
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | a3738f8bff1f4a32998fc197bd0a6b05              |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2033-04-23T18:25:43Z                          |
            | key                | #psp_transaction_id#                          |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is The indicated payment does not exist of v2/closepayment response


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SEM @NMU_CLOSE_SEM_2
    # identificativoPsp value check
    Scenario Outline: Check semantic error on idPSP
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | a3738f8bff1f4a32998fc197bd0a6b05              |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2033-04-23T18:25:43Z                          |
            | key                | #psp_transaction_id#                          |
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is The indicated PSP does not exist of v2/closepayment response
        Examples:
            | elem  | value       | soapUI test |
            | idPSP | 12345678987 | SEM_CP_03   |
            | idPSP | NOT_ENABLED | SEM_CP_04   |

            
    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SEM @NMU_CLOSE_SEM_3
    # identificativoIntermediario value check
    Scenario Outline: Check semantic error on idBrokerPSP
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | a3738f8bff1f4a32998fc197bd0a6b05              |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2033-04-23T18:25:43Z                          |
            | key                | #psp_transaction_id#                          |
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is The indicated brokerPSP does not exist of v2/closepayment response
        Examples:
            | elem        | value           | soapUI test |
            | idBrokerPSP | 12545678987     | SEM_CP_05   |
            | idBrokerPSP | INT_NOT_ENABLED | SEM_CP_06   |


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SEM @NMU_CLOSE_SEM_4
    # identificativoCanale value check
    Scenario Outline: Check semantic error on identificativoCanale
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | a3738f8bff1f4a32998fc197bd0a6b05              |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2033-04-23T18:25:43Z                          |
            | key                | #psp_transaction_id#                          |
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is The indicated channel does not exist of v2/closepayment response
        Examples:
            | elem      | value              | soapUI test |
            | idChannel | 12345671234_09     | SEM_CP_07   |
            | idChannel | CANALE_NOT_ENABLED | SEM_CP_08   |


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SEM @NMU_CLOSE_SEM_5
    # identificativoCanale not associated to BPAY [SEM_CPV2_09]
    Scenario: Check identificativoCanale not associated to BPAY
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | a3738f8bff1f4a32998fc197bd0a6b05              |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2033-04-23T18:25:43Z                          |
            | key                | #psp_transaction_id#                          |
        And idChannel with 60000000001_06 in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is Incorrect PSP-brokerPSP-Channel-Payment type configuration of v2/closepayment response


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SEM @NMU_CLOSE_SEM_6
    # identificativoCanale with Modello di pagamento = ATTIVATO PRESSO PSP [SEM_CPV2_10]
    Scenario: Check identificativoCanale ATTIVATO_PRESSO_PSP
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | a3738f8bff1f4a32998fc197bd0a6b05              |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2033-04-23T18:25:43Z                          |
            | key                | #psp_transaction_id#                          |
        And idChannel with #canale_ATTIVATO_PRESSO_PSP# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid payment type of v2/closepayment response


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SEM @NMU_CLOSE_SEM_7
    # identificativoIntermediario-identificativoCanale-identificativoPsp not associated [SEM_CPV2_11]
    Scenario: identificativoIntermediario-identificativoCanale-identificativoPsp not associated
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | a3738f8bff1f4a32998fc197bd0a6b05              |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2033-04-23T18:25:43Z                          |
            | key                | #psp_transaction_id#                          |
        And idPSP with IDPSPFNZ in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is Incorrect PSP-brokerPSP-Channel-Payment type configuration of v2/closepayment response