Feature:
  Scenario: 7
    Given db connection opened
    And Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select 3ds credit card
    And Confirm payment
    And Insert OTP
    And close the page
    And sleep 10 s
    Then check resultCode in METHOD_RESPONSE_3D2 is 25
    And check resultCode in CHALLENGE_RESPONSE_3D2 is 26
    And close db connection