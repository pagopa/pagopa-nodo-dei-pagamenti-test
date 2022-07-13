Feature: Denied authorisation
  Scenario: 8
    Given Payment generated with mock
    When Browse the payment response url
    And enter with the mail
    And Select cartaTest20_cvc4 credit card
    And Confirm payment
    Then Autorizzazione negata. is dislpayed


