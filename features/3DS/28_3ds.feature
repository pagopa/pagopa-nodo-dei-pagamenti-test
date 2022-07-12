Feature:
  Scenario: Payment with amex as registred user
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And select amex credit card
    And confirm payment