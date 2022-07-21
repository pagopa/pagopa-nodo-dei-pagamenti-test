Feature:
  Scenario: XPAY with Visa Cards 2
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And select CartaVisaXPAY2 credit card
    And confirm payment
    And sleep 100 s