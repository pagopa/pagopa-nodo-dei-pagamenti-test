Feature: new test file

  Scenario: test file for git
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select credit card
    And Confirm payment
    Then Payment is made successfully