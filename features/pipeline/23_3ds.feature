Feature:
  Scenario: 23
    Given db connection opened
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And Select 3ds credit card
    And Confirm payment
    And Insert OTP
    And Insert PIN
    And close the page
    And sleep 10 s
    Then check resultCode in METHOD_RESPONSE_3DS2 is 25
    Then check resultCode in CHALLENGE_RESPONSE_3DS2 is 26
    Then check resultCode in AUTH_RESPONSE_3DS2 is 00
    And close db connection