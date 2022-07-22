Feature: Holder with Special characters
  
  Scenario: Verify payment successfully of registered user with card with cardHolder containing Special characters
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select credit card with wrong card holder
    Then Check name error