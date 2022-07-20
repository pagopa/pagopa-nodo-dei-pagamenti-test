Feature:
  Scenario: 9
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select 3ds credit card
    And Confirm payment
    And Insert OTP
    And insert PIN
    Then check resultCode in METHOD_RESPONSE_3D2 is 25
    Then check resultCode in CHALLENGE_RESPONSE_3D2 is 26
    Then check resultCode in AUTH_RESPONSE_3D2 is 00