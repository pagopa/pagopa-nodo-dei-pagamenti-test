Feature:
  Scenario: 12
    Given Payment generated with mock
    When Browse the payment response url
    And sleep 600 s
    And Select enter with mail
