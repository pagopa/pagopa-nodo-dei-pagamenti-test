Feature:
  Scenario: XPAY with Visa Cards 1
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And select CartaVisaXPAY1 credit card
    And confirm payment
    And sleep 100 s
    Then Payment is made successfully


