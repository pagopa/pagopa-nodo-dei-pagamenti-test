Feature: Click on logo
  
  Scenario: Verify that the logo is not clickable after login
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    Then check logo is not clickable