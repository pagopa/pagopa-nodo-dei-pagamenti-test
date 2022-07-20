Feature:
  Scenario: 8
    Given db connection opened
    And Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select 3ds credit card
    And Confirm payment
    And Insert OTP
    And close the page
    Then check resultCode in METHOD_RESPONSE_3DS2 is 25
    And check resultCode in AUTH_RESPONSE_3DS2 column is 00
    And close db connection


