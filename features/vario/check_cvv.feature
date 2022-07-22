Feature: Check cvv

  Background:
    Given Payment generated with mock
    When Browse the payment response url

  Scenario: Check that cvv field in the browser is not predictive
    And Enter with the mail
    Then check cvv not predictive

  Scenario: Check that cvv is required for registred cards
    And Login as registered user
    And Select amex card from the list
    Then Check cvv is required