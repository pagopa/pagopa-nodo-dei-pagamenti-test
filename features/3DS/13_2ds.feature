Feature: 13_3d2
  Scenario: Payment with maestro as guest
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And select maestro credit card
    And confirm payment
    Then check resultCode in AUTH_RESPONSE_3DS2 column is 00