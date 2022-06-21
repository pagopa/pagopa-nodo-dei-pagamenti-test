Feature: Burger menu
  Scenario: Verify entries in burger menu after login
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    Then Check burger menu