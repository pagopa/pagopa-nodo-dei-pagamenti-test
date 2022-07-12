Feature:
  Scenario: 8
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select 3ds credit card
    And Confirm payment
    And Insert OTP
    Then close the page
