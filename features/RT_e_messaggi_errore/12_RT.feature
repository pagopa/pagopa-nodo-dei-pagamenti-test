Feature:
  Scenario: 12
    Given Payment generated with mock
    When Browse the payment response url
    And sleep 600 s
    And Enter with the mail
    And sleep 300 s
    And Select onus credit card
    And Cancel payment