Feature:
  Scenario: 22
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And Select 3ds credit card
    And Confirm payment
    And Insert OTP
    And close the page
    And sleep 5 s
    Then check resultCode in METHOD_RESPONSE_3D2 is 25
    Then check resultCode in CHALLENGE_RESPONSE_3D2 is 26