Feature: Your mail
  Scenario: Landing on privacy page when you enter your email.
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with your mail
    Then Check privacy page landing
