Feature: cvv predictive
  Scenario: Check that cvv field in the browser is not predictive
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    Then check cvv not predictive