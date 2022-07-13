Feature: 27_3d2
  
  Scenario: Payment with amex as registred user
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And select maestro credit card
    And confirm payment
    Then check resultCode in AUTH_RESPONSE_3DS2 column is 00