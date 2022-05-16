Feature: Syntax check closePyamentOutcome_v2

    Background:
        Given systems up
        And initial JSON closePayemntOutcome_v2
            """


            """

    Scenario Outline:
        Given outcome with OK in closePayemntOutcome_v2
        And <elem> with <value> in closePayemntOutcome_v2
        When psp sends REST closePayemntOutcome_v2 to nodo-dei-pagamenti
        Then check esito is KO of closePayemntOutcome_v2 response
        And check description is <description> of closePayemntOutcome_v2 response
        And verify the HTTP status code of closePayemntOutcome_v2 response is 400
        Examples:
            | elem              | value                                 | description                 | soapUI test |
            | paymentToken      | None                                  | paymentToken invalido       | SIN_CP_01   |
            | paymentToken      | Empty                                 | paymentToken invalido       | SIN_CP_02   |
            | paymentToken      | PSIrkQhfSQMrGMBownwbTnPqjkjaClBbVlnYE | paymentToken invalido       | SIN_CP_06   |
            | identificativoPsp | None                                  | identificativoPsp  invalido | SIN_CP_07   |
            | identificativoPsp | Empty                                 | identificativoPsp invalido  | SIN_CP_08   |
            | identificativoPsp | PSIrkQhfSQMrGMBownwbTnPqjkjaClBbVlnYE | identificativoPsp invalido  | SIN_CP_09   |
            | tipoVersamento    | None                                  | tipoVersamento invalido     | SIN_CP_10   |
            |transactionId | laKAWcpVKknpzaZchoSiZMQCapUyNjCWdhhcHbZsIHhywIGrlMhaGuOHjnfJVHhClYXmyqAzjvBXdrzSbDXPimLsFEFcmiWMqSFmtfflXdvABjjUNywHBDSHzvowySOsjDthiVwxXERkTrIBiCyysXTvZRjTcfKEXrhWIxZhaZHwISzzzgDtHItDeyPiWCulWMqXFLLDIWPQOVcAOuYtLvQZNAvIYzNlRQIewKuOlXulPoHQkszYOrkfgwYghtZA | transactionId invalido | SIN_CP_21 |
            | totalAmount | None | totalAmount invalido | SIN_CP_22 |
            | totalAmount | Empty | totalAmount invalido | SIN_CP_23 |
            | totalAmount | 51,00 | totalAmount invalido | SIN_CP_24 |
            | totalAmount | 51,150 | totalAmount invalido | SIN_CP_25 |
            | totalAmount | 


    Scenario Outline:
        Given outcome with <value> in closePaymentOutcome_v2
        When psp sends REST closePaymentOutcome_v2 to nodo-dei-pagamenti
        Then check esito is KO of closePaymentOutcome_v2 response
        And check description is "Outcome invalido" of closePaymentOutcome_v2 response
        And verify the HTTP status code of closePaymentOutcome_v2 response is 400
        Examples:
            | value | soapUI test |
            | None  | SIN_CP_04   |
            | Empty | SIN_CP_05   |
            | prova | SIN_CP_06   |

