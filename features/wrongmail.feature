Feature: Wrong mail
  Scenario: Error with wrong mail.
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with wrong mail
    Then Check wrong mail message


