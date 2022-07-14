Feature: Annulli
  Scenario: wait 10 minutes on annulli
    Given Payment generated with mock
    When Browse the payment response url
    Then Exit with annulla