Feature: 14_3d2

  Scenario: Payment with amex as guest
    Given db connection opened
    And Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And select amex credit card
    And confirm payment
    And close the page
    And sleep 10 s
    Then check resultCode in AUTH_RESPONSE_3DS2 is 00
    And close db connection