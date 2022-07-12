Feature:
  Scenario: 7
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select 3ds credit card
    And Confirm payment
    And sleep 300 s
    And Insert OTP
    Then sleep 1000 s