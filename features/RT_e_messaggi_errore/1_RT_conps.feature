Feature: Denied authorisation



    Scenario: Execute nodoInoltraEsito request
        When PSP sends SOAP nodoInoltraEsito to nodo-dei-pagamenti
        Then verify the HTTP status code of nodoInoltraEsito response is 200


    Scenario: 8
        Given Payment generated with mock
        When Browse the payment response url
        And enter with the mail
        And Select cartaTest20_cvc4 credit card
        And Confirm payment
        Then Autorizzazione negata. is dislpayed

