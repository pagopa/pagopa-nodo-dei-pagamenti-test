Feature:
  Scenario: Payment with amex as guest
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And select amex credit card
    And confirm payment
    #Then sleep 100 s