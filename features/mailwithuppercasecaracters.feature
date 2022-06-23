Feature:Mail with uppercase characters
  Scenario: Login with mail with uppercase characters.
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with mail with uppercase characters
    Then Login successfully as guest