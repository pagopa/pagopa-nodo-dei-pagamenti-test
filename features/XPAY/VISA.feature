Feature:
  Scenario: XPAY with Visa Cards
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And select CartaVisaXPAY1 card
    And confirm payment
    Then payment is made sucesfully