Feature:
  Scenario: 21
    Given db connection opened
    And Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And Select 3ds credit card
    And Confirm payment
    And Insert OTP
    And Insert PIN
    And close the page
    And sleep 10 s
    Then check resultCode in METHOD_RESPONSE_3D2 is 25
    Then check resultCode in CHALLENGE_RESPONSE_3D2 is 26
    And close db connection