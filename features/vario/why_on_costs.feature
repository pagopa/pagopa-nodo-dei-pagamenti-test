Feature: Why on costs
  Scenario: Why on maximum costs.
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select credit card
    And click on why costs
    Then check costs pop up