Feature: apro sito
  Scenario: apro il sito
    Given Payment generated with mock
    When Browse the payment response url
    Then sleep 1000 s
