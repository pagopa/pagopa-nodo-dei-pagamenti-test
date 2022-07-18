Feature: Annulli
  Scenario: wait 5 minutes on annulli
    Given Payment generated with mock
    When Browse the payment response url
    Then sleep 300 s
    And Select enter with mail