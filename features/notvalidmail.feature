Feature: Not valid mail
  Scenario: Error with not valid mail.
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with not valid mail
    Then Check not valid mail message

